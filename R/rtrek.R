globalVariables(c(".data"))

#' rtrek: Star Trek datasets and related R functions.
#'
#' The rtrek package contains a collection of Star Trek-themed datasets and R functions to assist with their use.
#'
#' @docType package
#' @name rtrek
NULL

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
    dataset = c("stGeo", "stSpecies", "stTiles"),
    description = c("Simple CRS data associated with map tile sets.", "Basic intelligent species data.",
                    "Available map tile sets."))
}
