#' Memory Alpha API
#'
#' Access Star Trek content from Memory Alpha (\url{http://memory-alpha.wikia.com}).
#'
#' @details
#' The content returned is always a data frame. The structure changes slightly depending on the nature of the endpoint,
#' but results from different endpoints can be merged easily.
#'
#' \subsection{Portals}{
#' At the highest level, passing \code{enpoind = "portals"} returns a data frame listing the available Memory Alpha portals supported by \code{rtrek}.
#' A column of relative URLs is also included for reference, but can be ignored.
#' }
#'
#' \subsection{Portal Categories}{
#' In all other cases, the endpoint string must begin with one of the valid portal IDs.
#' Passing only the ID returns a data frame with IDs and relative URLs associated with the available categories in the specific portal.
#' There are two additional columns, \code{group} and \code{subgroup}, that may provide additional grouping context for the entry IDs in larger tables.
#' As with the relative URLs, you do not have to make explicit use of these variables.
#' \cr\cr
#' Selecting a specific category within a portal is done by appending the portal ID in \code{endpoint} with the category ID, separated by a forward slash.
#' You can append nested subcategory IDs with forward slashes, provided they subcategories exist.
#' }
#'
#' \subsection{Articles}{
#' When the endpoint is neither a top-level portal or one of a portal's categories (or subcategories, if available), it is an article.
#' An article is a terminal node, meaning you cannot nest further. An article will be any entry whose URL does not begin with \code{Category:}.
#' In this case, the content returned is still a data frame for consistency, but differs substantially from the results of non-terminal endpoints.
#' \cr\cr
#' Memory Alpha is not a database containing convenient tables. Articles comprise the bulk of what Memory Alpha has to offer.
#' They are not completely unstructured text, but are loosely structured.
#' Some assumptions are made and \code{memory_alpha} returns a data frame containing article text and links.
#' It is up to the user what to do with this information, e.g., performing text analyses.
#' }
#'
#' \subsection{Additional notes}{
#' The \code{url} column included in results for context uses relative paths to save space. The full URLs all begin the same.
#' To visit a URL directly, prepend it with \code{http://memory-alpha.wikia.com/wiki/}.
#' \cr\cr
#' Also note that once you know the relative URL for an article, e.g., \code{"Worf"},
#' you do not need to traverse through one of the portals using an \code{endpoint} string to retrieve its content.
#' You can instead use \code{ma_article("Worf")}.
#' \cr\cr
#' \code{memory_alpha} provides an overview perspective on how content available at Memory Alpha is organized and can be searched for through
#' a variety of hierarchical layouts. And in some cases this structure that can be obtained in table form can be useful as data or metadata
#' in itself. Alternatively, \code{ma_article} is focused exclusively on pulling back content from known articles.
#' }
#'
#' @param endpoint character, See details.
#'
#' @return a data frame
#' @export
#' @seealso \code{\link{ma_article}}
#'
#' @examples
#' memory_alpha("portals") # show available portals
#' memory_alpha("people") # show portal categories for People portal
#' memory_alpha("people/Klingons") # show people in Klingons subcategory
#' memory_alpha("people/Klingons/Worf") # return terminal article content
memory_alpha <- function(endpoint){
  x <- .ma_portals
  if(endpoint == "portals") return(x)
  ep <- strsplit(endpoint, "/")[[1]]
  if(ep[1] %in% x$id){
    d <- do.call(paste0("ma_portal_", ep[1]), list())
  } else {
    stop("Invalid endpoint: portal ID.", call. = FALSE)
  }
  if(length(ep) == 1) return(d)
  ma_select(d, ep[-1], "id")
}

ma_portal_df <- function(portal, nodes = c("table", "span, a"), start_node_index = 1,
                         end_node_index = NULL, subgroups = FALSE, slice = NULL){
  x <- ma_base_add(ma_portal_url(portal)) %>% xml2::read_html() %>% rvest::html_nodes(nodes[1])
  if(is.null(end_node_index)) end_node_index <- length(x)
  idx <- start_node_index:end_node_index
  if(portal == "technology"){
    x <- list(rvest::html_nodes(x[idx], "span, b, a"))
  } else {
    x <- purrr::map(x[idx], ~rvest::html_children(.x) %>% rvest::html_nodes(nodes[2]))
  }
  if(!is.null(slice)) x <- x[slice]
  x1 <- purrr::map(x, ~rvest::html_text(.x))
  x2 <- purrr::map(x, ~ma_href(.x))
  .f <- function(x, y){
    x[!is.na(y)] <- NA
    trimws(as.character(x))
  }
  if(subgroups){
    d <- purrr::map2(x1, x2, ~dplyr::data_frame(
      id = .x[-1], url = .y[-1], group = trimws(.x[1]), subgroup = .f(.x, .y)[-1]) %>%
        tidyr::fill(.data[["subgroup"]]) %>% dplyr::filter(!is.na(.data[["url"]]))
    ) %>% dplyr::bind_rows()
  } else {
    d <- purrr::map2(x1, x2, ~dplyr::data_frame(
      id = .x, url = .y, group = .f(.x, .y)) %>%
        tidyr::fill(.data[["group"]]) %>% dplyr::filter(!is.na(.data[["url"]]))
    ) %>% dplyr::bind_rows()
  }
  if(portal == "technology") d <- ma_portal_technology_cleanup(d)
  d
}

ma_portal_df <- memoise::memoise(ma_portal_df)

ma_portal_alternate <- function(nodes = c("table", "span, b, a"), start_node_index = 5,
                                end_node_index = NULL, subgroups = TRUE, slice = NULL){
  ma_portal_df("alternate", nodes, start_node_index, end_node_index, subgroups, slice)
}

ma_portal_people <- function(nodes = c("table", "span, a"), start_node_index = 3,
                             end_node_index = NULL, subgroups = FALSE, slice = NULL){
  ma_portal_df("people", nodes, start_node_index, end_node_index, subgroups, slice)
}

ma_portal_science <- function(nodes = c("table", "span, a"), start_node_index = 2,
                              end_node_index = NULL, subgroups = FALSE, slice = 1){
  ma_portal_df("science", nodes, start_node_index, end_node_index, subgroups, slice)
}

ma_portal_society <- function(nodes = c("td", "span, a"), start_node_index = 4,
                              end_node_index = NULL, subgroups = FALSE, slice = c(1, 5)){
  ma_portal_df("society", nodes, start_node_index, end_node_index, subgroups, slice)
}

ma_portal_technology <- function(nodes = c("h2, table", "span, b, a"), start_node_index = 4,
                                 end_node_index = 7, subgroups = FALSE, slice = NULL){
  ma_portal_df("technology", nodes, start_node_index, end_node_index, subgroups, slice)
}

#' Read Memory Alpha article
#'
#' Read Memory Alpha article content and metadata.
#'
#' Article content is returned in a nested, tidy data frame.
#'
#' @param url character, article URL. Expects package-style short URL. See examples.
#' @param content_format character, the format of the article main text, \code{"xml"} or \code{"character"}.
#' @param content_nodes character, which top-level nodes in the article main text to retain.
#' @param browse logical, also open \code{url} in browser.
#'
#' @return a nested data frame
#' @export
#'
#' @examples
#' \dontrun{ma_article("Azetbur")}
ma_article <- function(url, content_format = c("xml", "character"),
                       content_nodes = c("h2", "h3", "p", "b", "ul"), browse = FALSE){
  content_format <- match.arg(content_format)
  url <- ma_base_add(url)
  tryCatch(
    x <- xml2::read_html(url),
    error = function(e) stop("Article not found.", call. = FALSE)
  )
  title <- rvest::html_node(x, ".page-header__title") %>% rvest::html_text()
  cats <- ma_article_categories(x)
  x <- rvest::html_nodes(x, ".WikiaArticle > #mw-content-text") %>% rvest::html_children()
  aside <- ma_article_aside(x)
  content <- x[which(rvest::html_name(x) %in% content_nodes)]
  if(content_format == "character") content <-  gsub(" Edit$", "", rvest::html_text(content))
  if(browse) utils::browseURL(url)
  dplyr::data_frame(title = title, content = list(content), metadata = list(aside), categories = list(cats))
}

#' Memory Alpha site search
#'
#' Perform a Memory Alpha site search.
#'
#' This function returns a data frame containing the title, truncated text preview, and relative URL for the first page of search results.
#' It does not recursively collate search results through subsequent pages of results.
#' There could be an unexpectedly high number of pages of results depending on the search query.
#' Since the general nature of this search feature seems relatively casual anyway, it aims only to provide a first page preview.
#'
#' @param text character, search query.
#' @param browse logical, open search results page in browser.
#'
#' @return a data frame
#' @export
#'
#' @examples
#' ma_search("Worf")
ma_search <- function(text, browse = FALSE){
  url <- paste0(ma_base_add("Special:Search?query="), gsub("\\s+", "+", text))
  x <- xml2::read_html(url) %>% rvest::html_node(".Results")
  x2 <- x %>% rvest::html_nodes("h1 > a")
  title <- rvest::html_text(x2)
  url <- ma_href(x2)
  text <- rvest::html_nodes(x, "article") %>% rvest::html_text() %>% strsplit("(\n|\t)+") %>%
    sapply("[", 3)
  if(browse) utils::browseURL(url)
  dplyr::data_frame(title = title, text = text, url = url)
}
