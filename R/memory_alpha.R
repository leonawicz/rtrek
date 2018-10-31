#' Memory Alpha API
#'
#' Access data from Memory Alpha (\url{http://memory-alpha.wikia.com}).
#'
#' Access data from Memory Alpha web pages using a category ID.
#' Subcategories are accessed by appending the specific subcategory's ID to \code{id} with a \code{:} separator.
#' Available top-level category IDs and associated subcategory options for \code{by} can be found by calling \code{mem_alpha} with no arguments.
#' See examples.
#'
#' The content returned is always a data frame (except when calling with no arguments).
#' When the \code{id} request refers to a category, the data frame contains the names and associated URLs of entries in the category.
#' Note that the URLs are relative. To visit a URL directly, append \code{http://memory-alpha.wikia.com/}.
#'
#' When the \code{id} request refers to a terminal content page rather than a category page,
#' the data frame contains the main text and other data associated with the entry.
#'
#' @param id character, category ID. See details.
#' @param by character, describes how terminal pages are grouped by subcategories.
#'
#' @return a data frame.
#' @export
#'
#' @examples
#' # show available top-level category IDs and associated subcategory options
#' mem_alpha()
#'
#' # people by species category
#' mem_alpha("people", by = "species")
#'
#' # subcategories and main pages under Klingon people-by-species subcategory
#' mem_alpha("people:Klingons", by = "species")
mem_alpha <- function(id, by = NULL){
  if(missing(id)) return(dplyr::select(ma_urls, -.data[["url"]]))
  base_id <- ma_base_get(id)
  if(!base_id %in% ma_urls$id) stop("Invalid `id`")
  if(is.null(by)) by <- dplyr::filter(ma_urls, .data[["id"]] == base_id)$by[1]
  url <- ma_url(base_id, by)
  ma_dispatch(id, by, url)
}

ma_people <- function(id, by, url){
  id <- strsplit(id, ":")[[1]]
  #grp <- html_nodes(x, ".mw-headline") %>% html_attr("id")
  x <- xml2::read_html(ma_base_add(url)) %>% rvest::html_nodes("td")
  txt <- rvest::html_text(x)
  tbl_idx <- switch(by, # switch statements because mixed tables in web page
                    species = grep("By species", txt)[1],
                    organization = grep("By organization", txt)[1],
                    occupation = grep("By occupation", txt)[1],
                    "ship/station" = grep("By ship or station", txt)[1],
                    origin = grep("By origin", txt)[1]
                    )
  x <- x[tbl_idx] %>% rvest::html_nodes("td") %>% rvest::html_nodes("a")
  x <- switch(by,
              species = x,
              organization = x[1:grep("Other organizations", x)],
              occupation = x[(grep("Other organizations", x) + 1):grep("Other occupations", x)],
              "ship/station" = x[1:grep("Other ships and stations", x)],
              origin = x[(grep("Other ships and stations", x) + 1):length(x)]
              )
  d <- dplyr::data_frame(rvest::html_text(x), ma_href(x)) %>% stats::setNames(c(by, "url"))
  if(length(id) == 1) return(d) # category lookup

  # category provided
  url <- dplyr::filter(d, grepl(id[2], .data[[by]], ignore.case = TRUE))$url
  dplyr::bind_rows(
    ma_all_pages(id[2], url, "#mw-subcategories"),
    ma_all_pages(id[2], url, "#mw-pages"))
}

ma_urls <- dplyr::data_frame(
  id = c(rep("people", 5)),
  url = c(
    rep("wiki/Portal:People", 5)
  ),
  by = c("species", "organization", "occupation", "ship/station", "alternate reality")
)

ma_base_url <- "http://memory-alpha.wikia.com"
ma_base_add <- function(x) file.path(ma_base_url, x)
ma_base_strip <- function(x) gsub(ma_base_url, "", x)
ma_base_get <- function(x) strsplit(x, ":")[[1]][1]

ma_url <- function(id, by){
  d <- dplyr::filter(ma_urls, .data[["id"]] == id)$url[1]
}

ma_dispatch <- function(id, by, url){
  base_id <- ma_base_get(id)
  .f <- switch(
    base_id,
    people = ma_people
  )
  .f(id, by, url)
}

ma_href <- function(x){
  gsub("^/", "", rvest::html_attr(x, "href"))
}

ma_all_pages <- function(id, url, node, d0 = NULL){
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
