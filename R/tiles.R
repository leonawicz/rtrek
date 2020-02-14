#' Simple CRS coordinates
#'
#' Convert \code{(column, row)} numbers to \code{(x, y)} coordinates for a given tile set.
#'
#' This function converts column and row indices for an available map tile set matrix to coordinates that can be used in a Leaflet map. See \code{\link{stTiles}} for available tile sets.
#'
#' \code{data} cannot contain columns named \code{x} or \code{y}, which are reserved for the column-appended output data frame.
#'
#' Each tile set has a simple/non-geographical coordinate reference system (CRS). Respective coordinates are based on the dimensions of the source image used to generate each tile set.
#' The same column and row pair will yield different map coordinates for different tile sets. Typical for matrices, columns are numbered increasing from left to right and rows increasing from top to bottom.
#' The output of \code{tile_coords} is a typical Cartesian coordinate system, increasing from left to right and bottom to top.
#'
#' @param data a data frame containing columns named \code{col} and \code{row}. These contain column-row number pairs defining matrix cells in tile set \code{id}. See details.
#' @param id character, name of map tile set ID. See \code{\link{stTiles}}.
#'
#' @return a data frame.
#' @export
#'
#' @examples
#' d <- data.frame(row = c(0, 3222, 6445), col = c(0, 4000, 8000))
#' tile_coords(d, "galaxy1")
tile_coords <- function(data, id){
  if(!all(c("row", "col") %in% names(data))) stop("`data` must contain columns named `col` and `row`", call. = FALSE)
  if(any(c("x", "y") %in% names(data))) stop("`data` cannot contain columns named `x` or `y`", call. = FALSE)
  id0 <- id
  x <- dplyr::filter(rtrek::stTiles, .data[["id"]] == id0)
  w <- x$width
  h <- x$height
  if(id == "galaxy2"){ # not sure what happened with map 2
    w <- 8000
    h <- 6445
  }
  r <- h / w
  dplyr::mutate(data, x = 250 * col / w, y = -250 * r * row / h)
}

#' Return the url associated with a tile set
#'
#' This function returns the url associated with a tile set matching \code{id}.
#'
#' Tile set data are stored in the \code{\link{stTiles}} dataset. See for available IDs.
#'
#' @param id character, name of map tile set ID. See \code{\link{stTiles}}.
#'
#' @return a character string.
#' @export
#' @seealso \code{\link{stTiles}}, \code{\link{st_tiles_data}}
#'
#' @examples
#' st_tiles("galaxy1")
st_tiles <- function(id){
  x <- rtrek::stTiles
  x$url[x$id == id]
}

#' Ancillary location data for map tiles
#'
#' Obtain a table of ancillary data associated with various locations of interest, given a specific map tile set ID.
#'
#' This function returns a small example data frame of location-specific data along with grid cell coordinates that are specific to the requested map tile set ID.
#'
#' @param id character, name of a map tile set.
#'
#' @return a data frame
#' @export
#' @seealso \code{\link{stTiles}}, \code{\link{st_tiles}}
#'
#' @examples
#' st_tiles_data("galaxy2")
st_tiles_data <- function(id){
  dplyr::filter(rtrek::stGeo, .data[["id"]] == !! id) %>%
    dplyr::mutate(body = "Planet", category = "Homeworld", zone = .st_zone, species = .st_species)
}
