#' Go to Wikipedia entry for a specific book series
#'
#' This function opens a browser tab to the main Wikipedia entry for all Star Trek novels automatically scrolled to the section pertaining to \code{id}.
#' To see the available IDs, call \code{st_books_wiki} with no arguments. The Wikipedia page is the one that serves as the source for the \code{stBooksWiki} dataset.
#'
#' The search IDs available in \code{st_books_wiki} do not represent an exhaustive set of Star Trek series.
#' For a more complete set of Star Trek series, miniseries and anthology names and acronyms, see the \code{\link{stSeries}} dataset.
#'
#' @param id character, abbreviation for a series. See details.
#'
#' @return opens a browser tab, nothing is returned unless \code{id} is not provided, in which case a data frame is returned.
#' @export
#' @seealso \code{\link{stBooksWiki}} \code{\link{stSeries}}
#'
#' @examples
#' st_books_wiki("DS9")
st_books_wiki <- function(id){
  x <- stBooksId
  if(missing(id)) return(dplyr::select(x, -.data[["id"]]))
  id <- x$id[x$abb == id]
  utils::browseURL(paste0("https://en.wikipedia.org/wiki/List_of_Star_Trek_novels#", id))
}
