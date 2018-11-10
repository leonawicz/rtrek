.ma_portals <- dplyr::data_frame(
  id = c("alternate", "people", "science", "series", "society", "technology"),
  url = paste0("Portal:", c("Alternate_Reality", "People", "Science",
                            "TV_and_films", "Society_and_Culture", "Technology"))
)

ma_portal_url <- function(id) .ma_portals$url[.ma_portals$id == id]

ma_base_url <- "http://memory-alpha.wikia.com/wiki"

ma_base_add <- function(x) file.path(ma_base_url, x)

ma_text <- function(x) trimws(rvest::html_text(x))

ma_href <- function(x) gsub(".*wiki/", "", rvest::html_attr(x, "href"))

# Recursively collate category pages and/or articles for nested endpoint
ma_select <- function(d, ep, .id){
  url <- dplyr::filter(d, .data[[.id]] == ep[1])$url
  if(!length(url)) stop(paste0("Invalid endpoint: ", ep[1], "."), call. = FALSE)
  if(grepl("^Category:", url)){
    d <- ma_category_pages(ep[1], url, c(".category-page__members", ".category-page__pagination"))
  } else {
    if(length(ep) > 1) stop(paste0("Invalid enpoint: ", ep[1],
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
  x1 <- rvest::html_nodes(x, nodes[1]) %>% rvest::html_nodes("a")
  txt <- ma_text(x1)
  url <- ma_href(x1)
  d <- dplyr::data_frame(txt, url) %>% stats::setNames(c(id, "url"))
  if(!is.null(d0)) d <- dplyr::bind_rows(d0, d)

  x <- rvest::html_nodes(x, nodes[2]) %>% rvest::html_nodes("a")
  if(!length(x)) return(d)
  txt <- ma_text(x)
  url <- ma_href(x)
  idx <- grep("^(\\n|\\t)+Next(\\n|\\t)+$", txt)
  if(!length(idx)){
    d
  } else {
    Recall(id, url[idx[1]], nodes, d)
  }
}

ma_category_pages <- memoise::memoise(ma_category_pages)

ma_portal_technology_cleanup <- function(d){
  dplyr::mutate(d,
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
  x <- rvest::html_node(x, "#articleCategories") %>% rvest::html_nodes("li span a")
  x <- x[!grepl(".*Category:Memory_Alpha_pages_with.*", x)]
  url <- ma_href(x)
  x <- ma_text(x)
  dplyr::data_frame(categories = x, url = url)
}

ma_article_aside <- function(x){
  x <- x[[which(rvest::html_name(x) == "aside")[1]]] %>% rvest::html_children()
  x <- x[which(rvest::html_name(x) == "div")]
  cols <- rvest::html_nodes(x, ".pi-data-label") %>% ma_text()
  cols <- gsub(":$", "", cols)
  cols <- gsub("\\s", "_", cols)
  x <- rvest::html_nodes(x, ".pi-data-value")
  if(length(x) != length(cols)){
    warning("Summary card cannot be parsed. Metadata column will be NULL.")
    return()
  }
  vals <- purrr::map(x, ~{
    x <- xml2::xml_contents(.x) %>% ma_text()
    x[x %in% c("", " ")] <- "|"
    x <- gsub("\\)", "\\)|", x)
    x <- gsub("[|]+$", "", gsub("[|]+", "|", paste0(x, collapse = "")))
    x <- gsub(", [|]|,[|]", "|", x)
    x
  }) %>% stats::setNames(cols)
  dplyr::as_data_frame(vals)
}
