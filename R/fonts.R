#' Preview Star Trek fonts
#'
#' This function produces a plot showing a preview of a Star Trek font from the \code{trekfont} package.
#' It will return a message if any of \code{trekfont}, \code{showtext} or \code{ggplot2} are not installed.
#' If \code{family} is missing, it will return a vector of all available font families.
#'
#' In RStudio on Windows the font may not show in the RStudio graphics device. Try using the regular R GUI.
#'
#' @param family character, font family.
#'
#' @return a character vector, or a plot side effect. See details.
#' @export
#'
#' @examples
#' library(showtext)
#' showtect_auto()
#' st_font()
#' st_font("Federation")
st_font <- function(family){
  if(!requireNamespace("trekfont", quietly = TRUE)){
    message("The `trekfont` package is not installed.")
    return(invisible())
  }
  if(!requireNamespace("showtext", quietly = TRUE)){
    message("The `showtext` package must be installed to preview fonts.")
    return(invisible())
  }
  if(!requireNamespace("showtext", quietly = TRUE)){
    message("The `ggplot2` package must be installed to preview fonts.")
    return(invisible())
  }
  if(missing(family)) return(gsub("\\.ttf|\\.otf", "", trekfont::trekfonts))
  ext <- ifelse(length(grep("Montalban", family)), ".otf", ".ttf")
  font <- paste0(system.file("fonts", package = "trekfont"), "/", family, ext)
  sysfonts::font_add(family = "stfont", font)
  g <- grid::rasterGrob(.worf, interpolate = TRUE)
  x0a <- "THE QUICK BROWN FOX"
  x0b <- "jumps over the lazy dog."
  x <- "The Quick Brown Fox Jumps Over The Lazy Dog."
  x <- c(tolower(x), x, toupper(x))
  x2 <- '"Captain, this font is strong.\nI recommend extreme caution."'
  showtext::showtext_auto()
  ggplot2::ggplot() + ggplot2::theme_gray(base_family = "stfont") +
    ggplot2::theme(plot.margin = grid::unit(c(2, 4, 2, 2), "mm")) +
    ggplot2::coord_cartesian(xlim = c(0, 1), ylim = c(0, 1)) +
    ggplot2::scale_x_continuous(expand = c(0.01, 0)) +
    ggplot2::scale_y_continuous(expand = c(0.01, 0)) +
    ggplot2::annotation_custom(g, xmin = 0.7, xmax = 1, ymin = 0.72, ymax = Inf) +
    ggplot2::labs(title = x0a, subtitle = x0b) +
    ggplot2::annotate("text", x = 0, y = 0.5, hjust = 0, label = x[1], family = "stfont") +
    ggplot2::annotate("text", x = 0, y = 0.43, hjust = 0, label = x[2], family = "stfont") +
    ggplot2::annotate("text", x = 0, y = 0.36, hjust = 0, label = x[3], family = "stfont") +
    ggplot2::annotate("text", x = 0, y = 0.17, hjust = 0,
                      label = paste0(tolower(x0a), "\nJUMPS OVER\nTHE LAZY DOG."),
                      family = "stfont", size = 11) +
    ggplot2::annotate("text", x = 1, y = 0.65, hjust = 1, label = x2, family = "stfont")
}
