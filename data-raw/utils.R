# Inject parallax into body of Stellar Cartography web page, remove title div
.post_proc_html <- function(id = "sc"){
  font_title <- "@font-face {
    font-family: 'sc-title-font';
    src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/FederationStarfleet.ttf') format('truetype');
  }\n"
  font_title2 <- "@font-face {
    font-family: 'tng-title-font';
    src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/StarNext.ttf') format('truetype');
  }\n"
  font_subtitle <- "@font-face {
    font-family: 'sc-subtitle-font';
  src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/FederationDS9Title.ttf') format('truetype');
  }\n"
  font_h2 <- "@font-face {
    font-family: 'sc-h2-font';
    src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/Federation.ttf') format('truetype');
  }\n"
  font_h4 <- "@font-face {
    font-family: 'sc-h4-font';
    src: url('https://raw.githubusercontent.com/leonawicz/trekfont/master/inst/fonts/Federation.ttf') format('truetype');
  }\n"

  par_title <- '\n.parallax-title {
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

  par_title2 <- '\n.parallax-title {
    position: absolute;
    top: 70px;
    left: 190px;
    color: #ffffff;
    font-family: "tng-title-font";
    font-size: 6em;
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

  rrjs <- paste0("<script type='text/javascript'>\n", paste0(readLines("data-raw/rr.js"), collapse = "\n"), "\n</script>\n\n")
  rr_content <- paste0(paste0(readLines("data-raw/rr.html"), collapse = "\n"), '\n\n')
  rr2_content <- paste0(paste0(readLines("data-raw/rr2.html"), collapse = "\n"), '\n\n')

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

  rr <- paste0(
    '<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>\n',
    '<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>\n', rrjs, "\n\n",
    '<style>body { background-color: #222222; color: #ffffff; } h2 {font-family: "sc-h2-font"; } h4 {font-family: "sc-h4-font"; }\n',
    '.parallax { background-image: url("https://raw.githubusercontent.com/leonawicz/rtrek/master/data-raw/images/tf.jpg"); }\n',
    '#ds9-parallax { background-image: url("https://raw.githubusercontent.com/leonawicz/rtrek/master/data-raw/images/qb.jpg"); }\n',
    font_title2, font_subtitle, font_h2, font_h4, par_title2, par_subtitle, '</style>\n\n',
    '<div class="main-container">\n  <div class="parallax">\n    ',
    '<a href="https://github.com/leonawicz/rtrek/">\n      ',
    '<h1 class="parallax-title"><span style="padding-right: 50px;">Ten Forward</span></h1>',
    '<h1 class="parallax-subtitle"><span style="padding-right: 50px;">Matthew Leonawicz ◆ R Developer</span></h1>',
    '<img class="parallax-image" ',
    'src="https://raw.githubusercontent.com/leonawicz/rtrek/master/data-raw/images/rtrek-small.png">',
    '\n    </a>\n  </div>\n\n')
  rr2 <- paste0('</div>\n<div id="ds9-parallax" class="parallax">\n    ',
  '<h1 style="padding:20px 0px 0px 20px;font-family:sc-subtitle-font;font-size:6em;"><span style="padding-right: 50px;">Quark\'s Bar</span></h1>',
  '<h2 style="padding-left:20px;padding-top:0px;font-family:sc-subtitle-font;font-size:3em;"><span style="padding-right: 50px;">Deep Space 9 Promenade</span></h2>',
  '\n</div>\n\n<div class="container template-article">\n')

  x <- switch(id, sc = sc, rr = rr)
  file <- switch(id, sc = "docs/articles/sc.html", rr = "docs/articles/rr.html")
  l <- readLines(file)
  if(id == "rr"){
    file.copy("data-raw/tweet-data/tngtweets.json", "docs/tngtweets.json", overwrite = TRUE)
    idx <- grep("</header>", l) - 1
    idx2 <- grep("<footer>", l)
    if(id == "rr") rr_content <- c(rr_content, rr2, rr2_content)
    l <- c(l[1:idx], "</header>\n\n", rr_content, l[idx2:length(l)])
  } else {
    idx <- grep("<div class=\"page-header toc-ignore\">", l)
    idx2 <- grep("</div>", l)
    idx <- idx:(idx2[idx2 > idx][2])
    l <- l[-c(idx, idx + 1)]
  }
  idx <- grep("<body>", l)
  l <- c(l[1:idx], x, l[(idx + 1):length(l)])
  if(id == "rr"){
    idx <- grep("</body>", l)
    l[idx] <- paste0("</div>\n", l[idx])
  }
  writeLines(l, file)
  invisible()
}

build_site <- function(){
  pkgdown::build_site()
  .post_proc_html(id = "sc")
  .post_proc_html(id = "rr")
}

build_articles <- function(){
  pkgdown::build_articles()
  .post_proc_html(id = "sc")
  .post_proc_html(id = "rr")
}

build_article <- function(id = "sc"){
  pkgdown::build_article(id)
  .post_proc_html(id = id)
}

# Load existing, download new, append, resave and return full tweets data frame
update_local_tweets <- function(users, file, n = 3200){
  d <- if(file.exists(file)) readRDS(file) else NULL
  if(is.null(d)){
    last <- vector("list", length(users))
  } else {
    x <- dplyr::group_by(d, screen_name) %>% dplyr::summarise(status_id = status_id[1]) %>%
      dplyr::slice(match(users, screen_name))
    last <- as.list(x$status_id)
    names(last) <- x$screen_name
  }
  d2 <- purrr::map2(users, last, ~rtweet::get_timeline(.x, n = n, since_id = .y)) %>% dplyr::bind_rows()
  if(nrow(d2) > 0) d2 <- dplyr::filter(d2, !is_retweet)
  if(nrow(d2) == 0) return(d)
  d2 <- dplyr::select(d2, c(1:5, 7, 13:14))
  d <- dplyr::bind_rows(d2, d)
  saveRDS(d, file = file)
  d
}

tame_tweets <- function(x, accounts = "RikerGoogling"){
  stopwords <- readLines("https://raw.githubusercontent.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en")
  unstopwords <- c("lovemaking", "nudity", "nude", "erotic", "suck") # undo excess removal of normal tweets
  stopwords <- setdiff(stopwords, unstopwords)
  f <- function(text, stopwords){
    .inner <- function(x, words){
      !any(purrr::map_lgl(words, ~as.logical(length(grep(paste0("(^|\\s)", .x, "($|\\s)"), x)))))
    }
    purrr::map_lgl(text, ~.inner(.x, stopwords))
  }
  dplyr::filter(x, !(screen_name %in% accounts) | f(text, stopwords))
}
