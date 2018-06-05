#' Raster grid location data for stellar cartographic map tile sets.
#'
#' A data frame of with 18 rows and 4 columns. This data frame has an ID column for map tile set, a column of location names, and columns of respective column and row number of each location per map tile set.
#'
#' @format A data frame
"stGeo"

#' Species names and avatars, linked primarily from Memory Alpha.
#'
#' A data frame with 9 rows and 2 columns.
#'
#' @format A data frame
"stSpecies"

#' Available Star Trek map tile sets.
#'
#' A data frame with 2 row and 8 columns.
#'
#' @format A data frame
"stTiles"

#' Star Trek novel metadata from Wikipedia.
#'
#' A data frame with 715 rows and 6 columns containing metadata on Star Trek novels and other books taken from the primary Wikipedia page: https://en.wikipedia.org/wiki/List_of_Star_Trek_novels.
#' The data frame contains most of the novels but is not comprehensive, containing only the most easily scraped HTML table data, and may be out of date temporarily whenever new novels are published.
#'
#' There is considerable overlap in titles between \code{stBooksWP} and \code{stBooks}, but also a considerable number of unique entries.
#' For example, the old novelizations by James Blish of the Original Series episodes are not found in \code{stBooks}.
#'
#' @format A data frame
#' @seealso \code{\link{st_book_series}}, \code{\link{stBooks}}
"stBooksWP"

#' Star Trek novel metadata.
#'
#' A data frame with 743 rows and 11 columns containing metadata on Star Trek novels and other books taken from original books.
#' The data frame contains most of the novels but is not comprehensive and may be out of date temporarily whenever new novels are published.
#'
#' There is considerable overlap in titles between \code{stBooksWP} and \code{stBooks}, but also a considerable number of unique entries.
#' For example, the old novelizations by James Blish of the Original Series episodes are not found in \code{stBooks}. This dataset only goes back as far as 1979.
#'
#' However, \code{stBooks} contains a number of additional columns providing metadata about each book that could only be parsed from books and not from the Wikipedia page that serves as the source for \code{stBooksWP}.
#' These columns include the number of characters, words and chapters in a book. There may be some irregularities or erroneous entries based on the imperfect methods use to compile the metadata,
#' but it is overall an accurate dataset.
#'
#' @format A data frame
#' @seealso \code{\link{st_book_series}}, \code{\link{stBooksWP}}
"stBooks"

#' Star Trek API entities.
#'
#' A data frame with 40 rows and 4 columns listing the available STAPI entity IDs that can be passed to \code{\link{stapi}}, along with additional metadata regarding the content returned form an API call to each entity.
#' This data frame helps you see what you will obtain from API calls beforehand.
#' Every entity search returns a tibble data frame, with varying numbers of columns and different names depending on the entity content.
#' There is also one nested column containing the column names of the data frame returned for each entity. This can be inspected directly for specific entities or \code{stapiEntities} can be unnested with a function like \code{tidyr::unnest}.
#'
#' @format A data frame
#' @seealso \code{\link{stapi}}
"stapiEntities"

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
    dataset = c("stGeo", "stSpecies", "stTiles", "stBooks", "stBooksWP", "stapiEntities"),
    description = c("Map tile set locations of interest.", "Basic intelligent species data.",
                    "Available map tile sets.", "Star Trek novel metadata.", "Star Trek novel metadata from Wikipedia.",
                    "Star Trek API (STAPI) categories"))
}
