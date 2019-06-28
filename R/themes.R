#' ggplot2 themes
#'
#' A collection of ggplot2 themes.
#'
#' @param base_size base font size.
#' @param base_family base font family.
#' @param base_line_size base size for line elements.
#' @param base_rect_size base size for rect elements.
#'
#' @name theme_rtrek
#' @export
theme_rtrek <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                        base_rect_size = base_size/22){
  .theme_rtrek(base_size, base_family, base_line_size, base_rect_size)
}

#' @rdname theme_rtrek
#' @export
theme_rtrek_dark <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                             base_rect_size = base_size/22){
  clr <- c("#1A1A1A", "#222222", "#333333", "#CCCCCC", "#333333", "#1A1A1A")
  .theme_rtrek(base_size, base_family, base_line_size, base_rect_size, clr)
}

.theme_rtrek <- function(base_size = 11, base_family = "", base_line_size = base_size/22,
                         base_rect_size = base_size/22,
                         clr = c("#FFFFFF", "#FFFFFF", "#555555", "#555555", "#FFFFFF", "#EEEEEE")){
  ggplot2::theme_gray(base_size, base_family, base_line_size, base_rect_size) +
    ggplot2::theme(plot.background = ggplot2::element_rect(fill = clr[1]),
                   panel.background = ggplot2::element_rect(fill = clr[2]),
                   panel.grid = ggplot2::element_line(color = clr[6]),
                   legend.background = ggplot2::element_rect(color = clr[1], fill = clr[1]),
                   text = ggplot2::element_text(color = clr[4]),
                   legend.key = ggplot2::element_rect(fill = clr[2], color = clr[1]),
                   strip.background = ggplot2::element_rect(color = clr[1], fill = clr[5]),
                   strip.text = ggplot2::element_text(color = clr[4]),
                   axis.text = ggplot2::element_text(color = clr[3])
    )
}
