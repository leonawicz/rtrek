#' Go to Wikipedia entry for a specific book series
#'
#' This function opens a browser tab to the main Wikipedia entry for all Star Trek novels.
#' For a more complete set of Star Trek series, miniseries and anthology names and acronyms, see the [stSeries] and [stBooks] datasets.
#'
#' @return opens a browser tab, nothing is returned.
#' @export
#' @seealso [stBooks] [stSeries]
#'
#' @examples
#' \dontrun{st_books_wiki()}
st_books_wiki <- function(){
  utils::browseURL("https://en.wikipedia.org/wiki/List_of_Star_Trek_novels")
}
