.mb_portals <- dplyr::tibble(
  id = c("books", "comics", "characters", "culture", "games", "geography", "locations",
         "materials", "politics", "science", "starships", "technology", "timeline"),
  url = paste0("Category:", c("Books", "Comics", "Characters", "Culture", "Games", "Geography", "Locations",
                            "Materials_and_substances", "Politics", "Science", "Starships", "Technology", "Timeline"))
)

mb_base_url <- "http://memory-beta.wikia.com/wiki"

mb_base_add <- function(x) file.path(mb_base_url, x)

mb_text <- function(x, trim = TRUE) rvest::html_text(x, trim = trim)

mb_href <- function(x) gsub(".*wiki/", "", rvest::html_attr(x, "href"))

mb_strip_prefix <- function(x){
  x2 <- gsub("^Category:|^File:", "", x)
  if(length(unique(x2)) < length(unique(x))) x else x2
}

# Recursively collate category pages and/or articles for nested endpoint
mb_select <- function(d, ep, .id){
  url <- dplyr::filter(d, .data[[.id]] == ep[1])$url
  if(!length(url)) stop(paste0("Invalid endpoint: ", ep[1], "."), call. = FALSE)
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
  x1 <- rvest::html_nodes(x, nodes[1]) %>% rvest::html_nodes("ul a")
  x1 <- x1[grepl("class=\"category-page__member-link\"", x1)]
  txt <- mb_text(x1) %>% mb_strip_prefix()
  url <- mb_href(x1)
  d <- dplyr::tibble(txt, url) %>% stats::setNames(c(id, "url"))
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
  dplyr::tibble(categories = x, url = url)
}

mb_article_aside <- function(x){
  idx <- which(rvest::html_name(x) == "aside")
  if(!length(idx)) return()
  x <- x[[idx[1]]] %>% rvest::html_children()
  img <- .mb_aside_image(x)
  cols <- rvest::html_nodes(x, ".pi-data-label") %>% mb_text()
  cols <- gsub(":$", "", cols)
  cols <- gsub("\\s", "_", cols)
  x <- rvest::html_nodes(x, ".pi-data-value")
  if(length(x) != length(cols)) return()
  vals <- purrr::map(x, ~{
    x <- xml2::xml_contents(.x) %>% mb_text(trim = FALSE)
    x[x %in% c("", " ")] <- "|"
    x <- gsub("\\)", "\\)|", x)
    x <- gsub("[|]+$", "", paste0(x, collapse = ""))
    x <- gsub(", [|]|,[|]", "|", x)
    x <- gsub("[|](, | |,)", "|", x)
    x <- gsub("[|]+", "|", x)
    x <- gsub("[ ]+", " ", x)
    x <- gsub("^[|]", "", x)
    trimws(x)
  }) %>% stats::setNames(cols)
  d <- tibble::as_tibble(vals)
  dplyr::mutate(d, Image = img)
}

.mb_aside_image <- function(x){
  idx <- which(rvest::html_name(x) == "figure")[1]
  if(!length(idx)) return(as.character(NA))
  x <- rvest::html_nodes(x[idx], ".image-thumbnail") %>% mb_href()
  x <- strsplit(x, "/")[[1]]
  idx <- grep("\\.jpg", x, ignore.case = TRUE)
  if(!length(idx)) return(as.character(NA))
  paste0("File:", x[idx])
}
