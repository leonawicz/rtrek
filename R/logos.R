#' Star Trek logos
#'
#' Download an image of a Star Trek logo and return a ggplot object.
#'
#' By default the downloaded file is not retained (`keep = FALSE`). The filename
#' is derived from `url` if `file` is not provided. These files are all .gif.
#' Whether or not the output file is kept, a ggplot object of the image is returned.
#' For more information on attribution, see [stLogos()].
#'
#' @param url character, the url of the image, must be one from the dataset
#' [stLogos()]. See example.
#' @param file character, output file name. Optional. See details.
#' @param keep logical, if `FALSE` (default) then `file` is only temporary.
#'
#' @return a ggplot object
#' @export
#' @seealso [stLogos()]
#'
#' @examples
#' \dontrun{st_logo(stLogos$url[1])}
st_logo <- function(url, file, keep = FALSE){
  if(!requireNamespace("png", quietly = TRUE)){
    message("This function requires the pgn package. Install and rerun.")
    return(invisible())
  }
  path <- "https://raw.githubusercontent.com/leonawicz/treklogos/master/logos/png"
  url <- file.path(path, gsub("\\.gif", ".png", basename(url)))
  if(missing(file)) file <- basename(url)
  downloader::download(url, destfile = file, quiet = TRUE, mode = "wb")
  x <- png::readPNG(file)
  if(!keep) unlink(file, recursive = TRUE, force = TRUE)
  asp <- dim(x)[1] / dim(x)[2]
  x <- grid::rasterGrob(x, interpolate = TRUE)
  ggplot2::ggplot(geom = "blank") +
    ggplot2::annotation_custom(x, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
    ggplot2::theme(aspect.ratio = asp)
}
