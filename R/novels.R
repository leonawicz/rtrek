#' Go to Wikipedia entry for a specific book series
#'
#' This function opens a browser tab to the main Wikipedia entry for all Star Trek novels automatically scrolled to the section pertaining to \code{id}.
#' To see the available IDs, call \code{st_book_series} with no arguments.
#'
#' @param id character, abbreviation for a series. See details.
#'
#' @return opens a browser tab, nothing is returned unless \code{id} is not provided, in which case a data frame is returned.
#' @export
#' @seealso \code{\link{stBooks}}
#'
#' @examples
#' st_book_series()
#' st_book_series("DS9")
st_book_series <- function(id){
  x <- stBooksId
  if(missing(id)) return(dplyr::select(x, -.data[["id"]]))
  id <- x$id[x$abb == id]
  utils::browseURL(paste0("https://en.wikipedia.org/wiki/List_of_Star_Trek_novels#", id))
}
