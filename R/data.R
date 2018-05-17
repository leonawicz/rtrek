#' Raster grid location data for stellar cartographic map tile set 1.
#'
#' A data frame of with 7 rows and 6 columns.
#'
#' @format A data frame
"stGeo"

#' Species names and avatars, linked from Memory Alpha.
#'
#' A data frame of with 7 rows and 2 columns.
#'
#' @format A data frame
"stSpecies"

#' Available Star Trek map tile sets.
#'
#' A data frame of with 1 row and 8 columns.
#'
#' @format A data frame
"stTiles"

#' Star Trek novel metadata.
#'
#' A data frame of with 715 row and 6 columns containing metadata on Star Trek novels and other books taken from the primary Wikipedia page: https://en.wikipedia.org/wiki/List_of_Star_Trek_novels.
#' The data frame contains most of the novels but is not comprehensive, containing only the most easily scraped HTML table data, and may be out of date temporarily whenever new novels are published.
#'
#' @format A data frame
#' @seealso \code{\link{st_book_series}}
"stBooks"

#' Available datasets
#'
#' List the available datasets in the rtrek package.
#'
#' @return a character vector.
#' @export
#'
#' @examples
#' st_datasets()
st_datasets <- function(){
  dplyr::data_frame(
    dataset = c("stGeo", "stSpecies", "stTiles", "stBooks"),
    description = c("Simple CRS data associated with map tile sets.", "Basic intelligent species data.",
                    "Available map tile sets.", "Star Trek novel meta data from Wikipedia."))
}
