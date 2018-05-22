# Inject parallax into body of Stellar Cartography web page, remove title div
.post_proc_html <- function(id = "sc"){
  font_title <- "@font-face {
    font-family: 'sc-title-font';
    src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/FederationStarfleet.ttf') format('truetype');
  }\n"
  font_title2 <- "@font-face {
    font-family: 'sc-title2-font';
    src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/StarNext.ttf') format('truetype');
  }\n"
  font_subtitle <- "@font-face {
    font-family: 'sc-subtitle-font';
  src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/FederationDS9Title.ttf') format('truetype');
  }\n"
  font_h2 <- "@font-face {
    font-family: 'sc-h2-font';
  src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/FederationDS9Title.ttf') format('truetype');
  }\n"
  font_h4 <- "@font-face {
    font-family: 'sc-h4-font';
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

  par_title2 <- '\n.parallax-title{
    position: absolute;
    top: 70px;
    left: 190px;
    color: #ffffff;
      font-family: "sc-title2-font";
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

  tf_content <- '<div class="row">
  <div class="col-md-12">
  <h2>Welcome to the Ten Forward lounge</h2>
  <h4>Mingle with the ship’s complement.</h4>
  <p>This page is a work in progress.</p>
  </div>
  </div>

  <div class="row">
  <div class="col-md-8">
  <div id="picard" class="st-tweets">
  <h2>Captain Picard</h2>
  <p><a href="https://twitter.com/PicardTips">@PicardTips</a></p>
  <div style="padding:10px;float:left;"><img src="https://pbs.twimg.com/profile_images/416337864809402368/iSHIA4Zt_400x400.jpeg" style="border-radius:4px;border-color:#ffffff;border-size:10px;padding:0px;" height="180" width="180"></div>
  <h4></h4>
  </div>
  </div>
  <div class="col-md-4">
  <a class="twitter-timeline" data-width="100%" data-height="280" data-theme="dark" href="https://twitter.com/PicardTips?ref_src=twsrc%5Etfw">Tweets by PicardTips</a>
  </div>
  </div>

  <div class="row">
  <div class="col-md-4 contents">
  <a class="twitter-timeline" data-width="100%" data-height="280" data-theme="dark" href="https://twitter.com/WorfEmail?ref_src=twsrc%5Etfw">Tweets by WorfEmail</a>
  </div>
  <div class="col-md-4 contents">
  <a class="twitter-timeline" data-width="100%" data-height="280" data-theme="dark" href="https://twitter.com/RikerGoogling?ref_src=twsrc%5Etfw">Tweets by RikerGoogling</a>
  </div>
  </div><p>All tweets by <a href="https://twitter.com/JoeSondow">@JoeSondow</a></p>\n\n'

  sc <- paste0(
    '<style>body { background-color: #222222; color: #ffffff; } h2 {font-family: "sc-h2-font"; } h4 {font-family: "sc-h4-font"; }\n',
    '.parallax { background-image: url("https://i2.wp.com/movies.trekcore.com/gallery/albums/generationshd/generationshd1021.jpg"); }\n',
    font_title, font_subtitle, font_h2, font_h4, par_title, par_subtitle, '</style>',
    '<div class="main-container">\n  <div class="parallax">\n    ',
    '<a href="https://github.com/leonawicz/rtrek/">\n      ',
    '<h1 class="parallax-title"><span style="padding-right: 50px;">Stellar Cartography</span></h1>',
    '<h1 class="parallax-subtitle"><span style="padding-right: 50px;">Matthew Leonawicz ◆ R Developer</span></h1>',
    '<img class="parallax-image" ',
    'src="https://raw.githubusercontent.com/leonawicz/rtrek/master/data-raw/images/rtrek-small.png">',
    '\n    </a>\n  </div>\n</div>')

  tf <- paste0(
    '<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>\n',
    '<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>\n',
    '<style>body { background-color: #222222; color: #ffffff; } h2 {font-family: "sc-h2-font"; } h4 {font-family: "sc-h4-font"; }\n',
    '.parallax { background-image: url("https://vignette.wikia.nocookie.net/memoryalpha/images/6/68/Ten_Forward_%28overview%29.jpg/revision/latest?cb=20121210232354&path-prefix=en"); }\n',
    font_title2, font_subtitle, font_h2, font_h4, par_title2, par_subtitle, '</style>\n\n',
    '<div class="main-container">\n  <div class="parallax">\n    ',
    '<a href="https://github.com/leonawicz/rtrek/">\n      ',
    '<h1 class="parallax-title"><span style="padding-right: 50px;">Ten Forward</span></h1>',
    '<h1 class="parallax-subtitle"><span style="padding-right: 50px;">Matthew Leonawicz ◆ R Developer</span></h1>',
    '<img class="parallax-image" ',
    'src="https://raw.githubusercontent.com/leonawicz/rtrek/master/data-raw/images/rtrek-small.png">',
    '\n    </a>\n  </div>\n</div>\n\n')

  x <- switch(id, sc = sc, tf = tf)
  file <- switch(id, sc = "docs/articles/sc.html", tf = "docs/articles/ten-forward.html")
  l <- readLines(file)
  if(id == "tf"){
    idx <- grep("</header>", l) - 1
    idx2 <- grep("<footer>", l)
    l <- c(l[1:idx], "</header>\n\n", tf_content, l[idx2:length(l)])
  } else {
    idx <- grep("<div class=\"page-header toc-ignore\">", l)
    idx2 <- grep("</div>", l)
    idx <- idx:(idx2[idx2 > idx][2])
    l <- l[-c(idx, idx + 1)]
  }
  idx <- grep("<body>", l)
  l <- c(l[1:idx], x, l[(idx + 1):length(l)])
  writeLines(l, file)
  invisible()
}

build_site <- function(){
  pkgdown::build_site()
  .post_proc_html(id = "sc")
  .post_proc_html(id = "tf")
}

build_articles <- function(){
  pkgdown::build_articles()
  .post_proc_html(id = "sc")
  .post_proc_html(id = "tf")
}

build_article <- function(id = "sc"){
  id2 <- id
  if(id == "tf") id2 <- "ten-forward"
  pkgdown::build_article(id2)
  .post_proc_html(id = id)
}
