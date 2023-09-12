globalVariables(c(".data"))

#' rtrek: Data analysis relating to Star Trek.
#'
#' The `rtrek` package contains a collection of Star Trek-themed datasets and R
#' functions to assist with their use. The package interfaces with the Star Trek
#' API (STAPI), Memory Alpha and Memory Beta to retrieve data, metadata and
#' other information relating to the Star Trek fictional universe.
#'
#' The package also contains several local datasets covering a variety of topics
#' such as Star Trek timeline data, universe species data and geopolitical data.
#' Some of these are more information rich, while others are toy examples useful
#' for simple demonstrations. The bulk of Star Trek data is accessed from
#' external sources by API. A future version of `rtrek` will also include
#' summary datasets resulting from text mining analyses of Star Trek novels.
#'
#' @docType package
#' @name rtrek
#' @aliases rtrek-package
NULL

#' @importFrom memoise memoise
#' @importFrom tidyr fill unnest
#' @importFrom tibble tibble
NULL
