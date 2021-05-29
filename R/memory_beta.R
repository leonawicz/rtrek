#' Memory Beta API
#'
#' Access Star Trek content from Memory Beta (\url{https://memory-beta.fandom.com/wiki/Main_Page}).
#'
#' @details
#' The content returned is always a data frame. The structure changes slightly depending on the nature of the endpoint,
#' but results from different endpoints can be merged easily.
#'
#' \subsection{Portals}{
#' At the highest level, passing \code{enpoind = "portals"} returns a data frame listing the available Memory Beta portals supported by \code{rtrek}.
#' A column of relative URLs is also included for reference, but can be ignored. Compared to Memory Alpha, Memory Beta does not technically offer "portals",
#' but for consistency in \code{rtrek}, several high level categories on Memory Beta are treated as portal options.
#' See \code{\link{memory_alpha}} for comparison.
#' }
#'
#' \subsection{Portal categories}{
#' In all other cases, the endpoint string must begin with one of the valid portal IDs.
#' Passing only the ID returns a data frame with IDs and relative URLs associated with the available categories in the specific portal.
#' Unlike \code{memory_alpha}, there are no \code{group} or \code{subgroup} columns.
#' Memory Beta offers a more consistent reliance on the simple hierarchy of categories and articles.
#' \cr\cr
#' Selecting a specific category within a portal is done by appending the portal ID in \code{endpoint} with the category ID, separated by a forward slash.
#' You can append nested subcategory IDs with forward slashes, provided the subcategories exist.
#' }
#'
#' \subsection{Articles}{
#' When the endpoint is neither a top-level portal or one of a portal's categories (or subcategories, if available), it is an article.
#' An article is a terminal node, meaning you cannot nest further. An article will be any entry whose URL does not begin with \code{Category:}.
#' In this case, the content returned is still a data frame for consistency, but differs substantially from the results of non-terminal endpoints.
#' \cr\cr
#' Memory Beta is not a database containing convenient tables. Articles comprise the bulk of what Memory Beta has to offer.
#' They are not completely unstructured text, but are loosely structured.
#' Some assumptions are made and \code{memory_beta} returns a data frame containing article text and links.
#' It is up to the user what to do with this information, e.g., performing text analyses.
#' }
#'
#' \subsection{Additional notes}{
#' The \code{url} column included in results for context uses relative paths to save space. The full URLs all begin the same.
#' To visit a URL directly, prepend it with \code{https://memory-beta.fandom.com/wiki/}.
#' \cr\cr
#' Also note that once you know the relative URL for an article, e.g., \code{"Worf,_son_of_Mogh"},
#' you do not need to traverse through one of the portals using an \code{endpoint} string to retrieve its content.
#' You can instead use \code{mb_article("Worf,_son_of_Mogh")}.
#' \cr\cr
#' \code{memory_beta} provides an overview perspective on how content available at Memory Beta is organized and can be searched for through
#' a variety of hierarchical layouts. And in some cases this structure that can be obtained in table form can be useful as data or metadata
#' in itself. Alternatively, \code{mb_article} is focused exclusively on pulling back content from known articles.
#' }
#'
#' @param endpoint character, See details.
#'
#' @return a data frame
#' @export
#' @seealso \code{\link{mb_article}}, \code{\link{memory_alpha}}
#'
#' @examples
#' memory_beta("portals") # show available portals
#' endpoint <- "characters/Characters by races and cultures/Klingonoids/Klingons"
#' \donttest{
#' x <- memory_beta(endpoint)
#' x <- x[grep("Worf", x$Klingons), ]
#' x
#' memory_beta(paste0(endpoint, "/Worf, son of Mogh")) # return terminal article content
#' }
memory_beta <- function(endpoint){
  x <- .mb_portals
  if(endpoint == "portals") return(x)
  ep <- strsplit(endpoint, "/")[[1]]
  if(ep[1] %in% x$id){
    d <- mb_category_pages(ep[1], x$url[x$id == ep[1]],
                           c(".category-page__members", ".category-page__pagination"))
  } else {
    stop("Invalid endpoint: portal ID.", call. = FALSE)
  }
  if(length(ep) == 1) return(d)
  mb_select(d, ep[-1], ep[1])
}

#' Read Memory Beta article
#'
#' Read Memory Beta article content and metadata.
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
#' \donttest{mb_article("Azetbur")}
mb_article <- function(url, content_format = c("xml", "character"),
                       content_nodes = c("h2", "h3", "h4", "p", "b", "ul", "dl", "table"), browse = FALSE){
  content_format <- match.arg(content_format)
  url <- mb_base_add(url)
  tryCatch(
    x <- xml2::read_html(url),
    error = function(e) stop("Article not found.", call. = FALSE)
  )
  title <- rvest::html_node(x, ".page-header__title") %>% mb_text()
  cats <- mb_article_categories(x)
  x <- rvest::html_nodes(x, ".WikiaArticle > #mw-content-text > .mw-parser-output") %>% rvest::html_children()
  aside <- mb_article_aside(x)
  content <- x[which(rvest::html_name(x) %in% content_nodes & !grepl("<aside.*aside>", x))]
  if(content_format == "character") content <- gsub("\\[edit.*", "", mb_text(content))
  if(browse) utils::browseURL(url)
  dplyr::tibble(title = title, content = list(content), metadata = list(aside), categories = list(cats))
}

#' Memory Beta site search
#'
#' Perform a Memory Beta site search.
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
#' \donttest{mb_search("Worf")}
mb_search <- function(text, browse = FALSE){
  url <- paste0(mb_base_add("Special:Search?query="), gsub("\\s+", "+", text))
  x <- xml2::read_html(url) %>% rvest::html_node(".unified-search__results")
  x <- rvest::html_nodes(x, "li article") %>% mb_text() %>% strsplit("(\n|\t)+")
  if(browse) utils::browseURL(url)
  dplyr::tibble(title = sapply(x, "[", 1), text = sapply(x, "[", 2), url = sapply(x, "[", 3))
}

#' Memory Beta images
#'
#' Download a Memory Beta image and return a ggplot object.
#'
#' By default the downloaded file is not retained (\code{keep = FALSE}). The filename is derived from \code{url} if \code{file} is not provided.
#' Whether or not the output file is kept, a ggplot object of the image is returned.
#'
#' @param url character, the short url of the image, for example as returned by \code{memory_beta}. See example.
#' @param file character, output file name. Optional. See details.
#' @param keep logical, if \code{FALSE} (default) then \code{file} is only temporary.
#'
#' @return a ggplot object
#' @export
#'
#' @examples
#' \dontrun{mb_image("File:DataBlaze.jpg")}
mb_image <- function(url, file, keep = FALSE){
  url <- gsub(",", "%2C", url)
  file0 <- gsub("^File:|,", "", url)
  url2 <- xml2::read_html(mb_base_add(url)) %>%
    rvest::html_nodes("a img") %>%
    rvest::html_attr("src")
  url2 <- url2[grepl("^http", url2)]
  idx <- grep(file0, url2)
  if(!length(idx)) stop("Source file not accessible.", call. = FALSE)
  url2 <- url2[idx[1]]
  url2 <- gsub("latest/scale-to-width-down/\\d+\\?", "latest?", url2)
  if(missing(file)) file <- gsub(" ", "_", file0)
  file <- gsub("jpeg$", "jpg", file)
  downloader::download(url2, destfile = file, quiet = TRUE, mode = "wb")
  x <- jpeg::readJPEG(file)
  if(!keep) unlink(file, recursive = TRUE, force = TRUE)

  asp <- dim(x)[1] / dim(x)[2]
  x <- grid::rasterGrob(x, interpolate = TRUE)
  ggplot2::ggplot(geom = "blank") +
    ggplot2::annotation_custom(x, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
    ggplot2::theme(aspect.ratio = asp)
}
