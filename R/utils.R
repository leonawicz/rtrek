# Inject parallax into body of Stellar Cartography web page, remove title div
.post_proc_html <- function(id = "sc"){
  sc <- paste0(
    '<div class="main-container">\n  <div class="parallax">\n    ',
    '<a href="https://github.com/leonawicz/rtrek/">\n      ',
    '<h1 class="parallax-title"><span style="padding-right: 50px;">Stellar Cartography</span></h1>',
    '<img class="parallax-image" ',
    'src="https://raw.githubusercontent.com/leonawicz/rtrek/master/data-raw/images/rtrek-small.png">',
    '\n    </a>\n  </div>\n</div>')
  x <- switch(id, sc = sc)
  file <- switch(id, sc = "docs/articles/sc.html")
  l <- readLines(file)
  idx <- grep("<div class=\"page-header toc-ignore\">", l)
  idx2 <- grep("</div>", l)
  idx <- idx:(idx2[idx2 > idx][2])
  l <- l[-c(idx, idx + 1)]
  idx <- grep("<body>", l)
  l <- c(l[1:idx], x, l[(idx + 1):length(l)])
  writeLines(l, file)
  invisible()
}
