.ma_portals <- dplyr::data_frame(
  id = c("alternate", "people", "science", "society", "technology"),
  url = paste0("Portal:", c("Alternate_Reality", "People", "Science", "Society_and_Culture", "Technology"))
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
                                   " is an article but `endpoint` does not terminate here."))
    d <- ma_article(url, browse = FALSE, data_format = "data_frame")
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
