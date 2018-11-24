.mb_portals <- dplyr::data_frame(
  id = c("books", "comics", "characters", "culture", "games", "geography",
         "politics", "science", "starships", "technology", "timeline"),
  url = paste0("Category:", c("Books", "Comics", "Characters", "Culture", "Games", "Geography",
                            "Politics", "Science", "Starships", "Technology", "Timeline"))
)

mb_portal_url <- function(id) .mb_portals$url[.mb_portals$id == id]

mb_base_url <- "http://memory-beta.wikia.com/wiki"

mb_base_add <- function(x) file.path(mb_base_url, x)

mb_text <- function(x) trimws(rvest::html_text(x))

mb_href <- function(x) gsub(".*wiki/", "", rvest::html_attr(x, "href"))

mb_strip_prefix <- function(x){
  x2 <- gsub("^Category:|^File:", "", x)
  if(length(unique(x2)) < length(unique(x))) x else x2
}

# Recursively collate category pages and/or articles for nested endpoint
mb_select <- function(d, ep, .id){
  url <- dplyr::filter(d, .data[[.id]] == ep[1])$url
  if(!length(url)) stop(paste0("Invalid endpoint: ", ep[1], "."), call. = FALSE)
  print(url)
  if(grepl("^Category:", url)){
    d <- mb_category_pages(ep[1], url, c(".category-page__members", ".category-page__pagination"))
  } else {
    if(length(ep) > 1) stop(paste0("Invalid enpoint: ", ep[1],
                                   " is an article but `endpoint` does not terminate here."), call. = FALSE)
    d <- mb_article(url, browse = FALSE)
  }
  ep <- ep[-1]
  if(!length(ep)) return(d)
  Recall(d, ep, names(d)[1])
}

mb_select <- memoise::memoise(mb_select)

# Recursively collate all subcategories or articles for a given category's page(s)
mb_category_pages <- function(id, url, nodes, d0 = NULL){
  x <- xml2::read_html(mb_base_add(url))
  x1 <- rvest::html_nodes(x, nodes[1]) %>% rvest::html_nodes("a")
  txt <- mb_text(x1) %>% mb_strip_prefix()
  url <- mb_href(x1)
  d <- dplyr::data_frame(txt, url) %>% stats::setNames(c(id, "url"))
  if(!is.null(d0)) d <- dplyr::bind_rows(d0, d)

  x <- rvest::html_nodes(x, nodes[2]) %>% rvest::html_nodes("a")
  if(!length(x)) return(d)
  txt <- mb_text(x)
  url <- mb_href(x)
  idx <- grep("^Next$", txt)
  if(!length(idx)){
    d
  } else {
    Recall(id, url[idx[1]], nodes, d)
  }
}

mb_category_pages <- memoise::memoise(mb_category_pages)

mb_article_categories <- function(x){
  x <- rvest::html_node(x, "#articleCategories") %>% rvest::html_nodes("li span a")
  x <- x[!grepl(".*Category:Memory_Beta_pages_with.*", x)]
  url <- mb_href(x)
  x <- mb_text(x)
  dplyr::data_frame(categories = x, url = url)
}

mb_article_aside <- function(x){
  idx <- which(rvest::html_name(x) == "aside")
  if(!length(idx)) return()
  x <- x[[idx[1]]] %>% rvest::html_children()
  x <- x[which(rvest::html_name(x) == "div")]
  cols <- rvest::html_nodes(x, ".pi-data-label") %>% mb_text()
  cols <- gsub(":$", "", cols)
  cols <- gsub("\\s", "_", cols)
  x <- rvest::html_nodes(x, ".pi-data-value")
  if(length(x) != length(cols)){
    warning("Summary card cannot be parsed. Metadata column will be NULL.")
    return()
  }
  vals <- purrr::map(x, ~{
    x <- xml2::xml_contents(.x) %>% mb_text()
    x[x %in% c("", " ")] <- "|"
    x <- gsub("\\)", "\\)|", x)
    x <- gsub("[|]+$", "", gsub("[|]+", "|", paste0(x, collapse = "")))
    x <- gsub(", [|]|,[|]", "|", x)
    x
  }) %>% stats::setNames(cols)
  dplyr::as_data_frame(vals)
}
