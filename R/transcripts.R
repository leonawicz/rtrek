#' Import transcripts
#'
#' Download a curated data frame based on episode and movie transcripts
#' containing metadata and variables for analysis of scenes, character presence,
#' dialog, sentiment, etc.
#'
#' The data frame contains metadata associated with each transcript, one row per
#' episode. It also contains a list column. By default (`type = "clean"`), this
#' is a nested data frame of preprocessed text split into several variables
#' including the speaking character, line spoken, scene descriptions, etc. For
#' the raw text version, the list column contains vectors of unprocessed plain
#' text.
#'
#' Metadata includes the format (episode or movie), series, season, overall
#' episode number, title, production order and original airdate if available and
#' applicable. The two columns `url` and `url2` show where source material can
#' be browsed online, though not in a useful format for data analysis. The first
#' set is used if possible because it contains more complete, higher quality
#' data. When necessary, the derived data is based on text from the alternate
#' source.
#'
#' The dataset is nicely curated, but imperfect. There are text-parsing edge
#' cases that are difficult to handle generally. The quality varies
#' substantially across series. Datasets assembled based on original transcripts
#' are more informative, but not universally available. Other episodes are based
#' on transcripts derived from closed captioning, in which case more fields will
#' contain `NA` values.
#'
#' This function downloads and returns a sizable tibble data frame. Each version
#' is about 13-15 MB compressed. The returned tibble contains 726 rows (716
#' episodes and 10 movies), but each row has nested data.
#'
#' @param type character, `"clean"` for curated nested data frame or `"raw"` for
#' unprocessed text. See details.
#'
#' @return a tibble data frame
#' @export
#'
#' @examples
#' \dontrun{stTranscripts <- st_transcripts()}
st_transcripts <- function(type = c("clean", "raw")){
  type <- match.arg(type)
  .st_transcripts(type)
}

.st_transcripts <- function(x){
  url <- "https://raw.githubusercontent.com/leonawicz/trekscripts/master/"
  url <- paste0(url, ifelse(x == "clean", "prepped", "raw"), ".rds")
  file <- tempfile(basename(url))
  downloader::download(url, destfile = file, quiet = TRUE, mode = "wb")
  x <- readRDS(file)
  unlink(file, recursive = TRUE, force = TRUE)
  x
}

.st_transcripts <- memoise::memoise(.st_transcripts)
