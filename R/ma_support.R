.ma_portals <- dplyr::data_frame(
  id = c("alternate", "people", "science", "series", "society", "technology"),
  url = paste0("Portal:", c("Alternate_Reality", "People", "Science",
                            "TV_and_films", "Society_and_Culture", "Technology"))
)

ma_portal_url <- function(id) .ma_portals$url[.ma_portals$id == id]

ma_base_url <- "http://memory-alpha.wikia.com/wiki"

ma_base_add <- function(x) file.path(ma_base_url, x)

ma_href <- function(x) gsub(".*wiki/", "", rvest::html_attr(x, "href"))

# Recursively collate category pages and/or articles for nested endpoint
ma_select <- function(d, ep, .id){
  url <- dplyr::filter(d, .data[[.id]] == ep[1])$url
  if(!length(url)) stop(paste0("Invalid endpoint: ", ep[1], "."), call. = FALSE)
  if(grepl("^Category:", url)){
    d <- purrr::map(c("#mw-subcategories", "#mw-pages"), ~ma_category_pages(ep[1], url, .x)) %>%
      dplyr::bind_rows()
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
ma_category_pages <- function(id, url, node, d0 = NULL){
  x <- xml2::read_html(ma_base_add(url)) %>% rvest::html_nodes(node) %>% rvest::html_nodes("a")
  txt <- rvest::html_text(x)
  url <- ma_href(x)
  d <- dplyr::data_frame(txt, url) %>% stats::setNames(c(id, "url"))
  if(!is.null(d0)) d <- dplyr::bind_rows(d0, d)
  idx <- grep("next 200", txt)
  Sys.sleep(1)
  if(!length(idx)){
    dplyr::filter(d, !grepl("(previous|next) 200", .data[[id]]))
  } else {
    Recall(id, url[idx[1]], node, d)
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
  x <- rvest::html_text(x)
  dplyr::data_frame(categories = x, url = url)
}

ma_article_aside <- function(x){
  x <- x[[which(rvest::html_name(x) == "aside")[1]]] %>% rvest::html_children()
  x <- x[which(rvest::html_name(x) == "div")]
  cols <- rvest::html_nodes(x, ".pi-data-label") %>% rvest::html_text()
  cols <- gsub(":$", "", cols)
  cols <- gsub("\\s", "_", cols)
  x <- rvest::html_nodes(x, ".pi-data-value")
  if(length(x) != length(cols)){
    warning("Summary card cannot be parsed. Metadata column will be NULL.")
    return()
  }
  vals <- purrr::map(x, ~{
    x <- xml2::xml_contents(.x) %>% rvest::html_text()
    x[x %in% c("", " ")] <- "|"
    x <- gsub("\\)", "\\)|", x)
    x <- gsub("[|]+$", "", gsub("[|]+", "|", paste0(x, collapse = "")))
    x <- gsub(", [|]|,[|]", "|", x)
    x
  }) %>% stats::setNames(cols)
  dplyr::as_data_frame(vals)
}
