.ma_portals <- dplyr::tibble(
  id = c("alternate", "people", "science", "series", "society", "technology"),
  url = paste0("Portal:", c("Alternate_Reality", "People", "Science",
                            "TV_and_films", "Society_and_Culture", "Technology"))
)

ma_portal_url <- function(id) .ma_portals$url[.ma_portals$id == id]

ma_base_url <- "https://memory-alpha.fandom.com/wiki"

ma_base_add <- function(x) file.path(ma_base_url, x)

ma_text <- function(x, trim = TRUE) rvest::html_text(x, trim = trim)

ma_href <- function(x) gsub(".*wiki/", "", rvest::html_attr(x, "href"))

ma_strip_prefix <- function(x){
  x2 <- gsub("^Category:|^File:", "", x)
  if(length(unique(x2)) < length(unique(x))) x else x2
}

# Recursively collate category pages and/or articles for nested endpoint
ma_select <- function(d, ep, .id){
  url <- dplyr::filter(d, .data[[.id]] == ep[1])$url
  if(!length(url)) stop(paste0("Invalid endpoint: ", ep[1], "."), call. = FALSE)
  if(grepl("^Category:", url)){
    d <- ma_category_pages(ep[1], url, c(".category-page__members", ".category-page__pagination"))
  } else {
    if(length(ep) > 1) stop(paste0("Invalid endpoint: ", ep[1],
                                   " is an article but `endpoint` does not terminate here."), call. = FALSE)
    d <- ma_article(url, browse = FALSE)
  }
  ep <- ep[-1]
  if(!length(ep)) return(d)
  Recall(d, ep, names(d)[1])
}

ma_select <- memoise::memoise(ma_select)

# Recursively collate all subcategories or articles for a given category's page(s)
ma_category_pages <- function(id, url, nodes, d0 = NULL){
  x <- xml2::read_html(ma_base_add(url))
  x1 <- rvest::html_nodes(x, nodes[1]) |> rvest::html_nodes("ul a")
  x1 <- x1[grepl("class=\"category-page__member-link\"", x1)]
  txt <- ma_text(x1) |> ma_strip_prefix()
  url <- ma_href(x1)
  d <- dplyr::tibble(txt, url) |> stats::setNames(c(id, "url"))
  if(!is.null(d0)) d <- dplyr::bind_rows(d0, d)

  x <- rvest::html_nodes(x, nodes[2]) |> rvest::html_nodes("a")
  if(!length(x)) return(d)
  txt <- ma_text(x)
  url <- ma_href(x)
  idx <- grep("^Next$", txt)
  if(!length(idx)){
    d
  } else {
    Recall(id, url[idx[1]], nodes, d)
  }
}

ma_category_pages <- memoise::memoise(ma_category_pages)

ma_portal_technology_cleanup <- function(d){
  dplyr::mutate(
    d,
    group = ifelse(.data[["id"]] == "more", gsub("Category:", "", .data[["url"]]), .data[["group"]]),
    group = gsub(":$", "", .data[["group"]]),
    id = ifelse(.data[["id"]] == "more",
                paste("Other", tolower(gsub("Category:", "", .data[["url"]]))), .data[["id"]]),
    id = ifelse(grepl("^-[A-Z]$", .data[["id"]]),
                gsub("\\(|\\)", "", gsub("_", " ", .data[["url"]])), .data[["id"]])
  )
}

ma_portal_series_cleanup <- function(d){
  dplyr::mutate(d, id = gsub("^Star Trek( [IV]+|)(:|)( The | )(.*)", "\\4", .data[["id"]]))
}

ma_article_categories <- function(x){
  x <- rvest::html_node(x, "#articleCategories") |> rvest::html_nodes("li span a")
  x <- x[!grepl(".*Category:Memory_Alpha_pages_with.*", x)]
  url <- ma_href(x)
  x <- ma_text(x)
  dplyr::tibble(categories = x, url = url)
}

ma_article_aside <- function(x){
  x <- rvest::html_children(x)
  idx <- which(rvest::html_name(x)  == "aside")
  if(!length(idx)) return()
  x <- x[[idx[1]]] |> rvest::html_children()
  img <- .ma_aside_image(x)
  cols <- rvest::html_nodes(x, ".pi-data-label") |> ma_text()
  cols <- gsub(":$", "", cols)
  cols <- gsub("\\s", "_", cols)
  x <- rvest::html_nodes(x, ".pi-data-value")
  if(length(x) != length(cols)) return()
  vals <- purrr::map(x, ~{
    x <- xml2::xml_contents(.x) |> ma_text(trim = FALSE)
    x[x %in% c("", " ")] <- "|"
    x <- gsub("\\)", "\\)|", x)
    x <- gsub("[|]+$", "", paste0(x, collapse = ""))
    x <- gsub(", [|]|,[|]", "|", x)
    x <- gsub("[|](, | |,)", "|", x)
    x <- gsub("[|]+", "|", x)
    x <- gsub("[ ]+", " ", x)
    x <- gsub("^[|]", "", x)
    trimws(x)
  }) |> stats::setNames(cols)
  d <- tibble::as_tibble(vals)
  dplyr::mutate(d, Image = img)
}

.ma_aside_image <- function(x){
  idx <- which(rvest::html_name(x) == "figure")[1]
  if(!length(idx)) return(as.character(NA))
  x <- rvest::html_nodes(x[idx], ".image-thumbnail") |> mb_href()
  x <- strsplit(x, "/")[[1]]
  idx <- grep("\\.jpg", x, ignore.case = TRUE)
  if(!length(idx)) return(as.character(NA))
  paste0("File:", x[idx])
}
