# Inject parallax into body of Stellar Cartography web page, remove title div
.post_proc_html <- function(id = "sc"){
  font_title <- "@font-face {
    font-family: 'sc-h2-font';
    src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/FederationStarfleet.ttf') format('truetype');
  }\n"
  font_subtitle <- "@font-face {
    font-family: 'sc-h2-font';
  src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/FederationDS9Title.ttf') format('truetype');
  }\n"
  font_h2 <- "@font-face {
    font-family: 'sc-h2-font';
  src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/FederationDS9Title.ttf') format('truetype');
  }\n"
  font_h4 <- "@font-face {
    font-family: 'sc-h2-font';
    src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/Federation.ttf') format('truetype');
  }\n"

  par_title <- '\n.parallax-title{
    position: absolute;
    top: 70px;
    left: 190px;
    color: #ffffff;
      font-family: "sc-title-font";
    font-size: 4em;
    -webkit-animation: fadein 2s;
    -moz-animation: fadein 2s;
    -ms-animation: fadein 2s;
    -o-animation: fadein 2s;
    animation: fadein 2s;
  }\n'

  par_subtitle <- '\n.parallax-subtitle{
    position: absolute;
    top: 600px;
    left: 20px;
    color: #D0F8FF;
      font-family: "sc-subtitle-font";
    font-size: 1.2em;
    -webkit-animation: fadein 2s;
    -moz-animation: fadein 2s;
    -ms-animation: fadein 2s;
    -o-animation: fadein 2s;
    animation: fadein 2s;
  }\n'

  sc <- paste0(
    '<style>body {background-color: #222222; color: #ffffff; } h2 {font-family: "sc-h2-font"; } h4 {font-family: "sc-h4-font"; }</style>\n',
    font_title, font_subtitle, font_h2, font_h4, par_title, par_subtile,
    '<div class="main-container">\n  <div class="parallax">\n    ',
    '<a href="https://github.com/leonawicz/rtrek/">\n      ',
    '<h1 class="parallax-title"><span style="padding-right: 50px;">Stellar Cartography</span></h1>',
    '<h1 class="parallax-subtitle"><span style="padding-right: 50px;">Matthew Leonawicz ◆ R Developer</span></h1>',
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

build_site <- function(id = "sc"){
  pkgdown::build_site()
  .post_proc_html(id = id)
}

build_articles <- function(id = "sc"){
  pkgdown::build_article(id)
  .post_proc_html(id = id)
}

build_article <- function(id = "sc"){
  pkgdown::build_articles()
  .post_proc_html(id = id)
}
