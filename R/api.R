.stapi_entities <- c(
  "company", "comicStrip", "organization", "soundtrack", "character", "common/panel",
  "literature", "magazine", "videoRelease", "animal", "comicCollection", "staff",
  "common", "title", "astronomicalObject", "element", "common/panel/admin", "tradingCard",
  "comics", "tradingCardDeck", "magazineSeries", "videoGame", "technology", "comicSeries",
  "movie", "performer", "weapon", "episode", "season", "bookSeries", "conflict", "location",
  "spacecraftClass", "material", "species", "occupation", "bookCollection", "medicalCondition",
  "food", "tradingCardSet", "oauth/github", "book", "spacecraft", "series"
)

.stapi_dropcols <- c(
  paste0("title", c("Bulgarian", "Catalan", "ChineseTraditional", "German",
                    "Italian", "Japanese", "Polish", "Russian", "Serbian", "Spanish"))
)

#' List available STAPI entities
#'
#' Currently, this function simply lists the available entities for the Star Trek API (STAPI). See \code{\link{stapi}}.
#'
#' @return a character vector.
#' @export
#' @seealso \code{\link{stapi}}
#'
#' @examples
#' stapi_options()
stapi_options <- function() sort(.stapi_entities)

# nolint start

#' Retrieve Star Trek data from STAPI
#'
#' Retrieve Star Trek data from the Star Trek API (STAPI).
#'
#' See \code{\link{stapi_options}} for all the currently available API entities. These are the IDs for dataset collections or categories passed to \code{id}.
#'
#' The universal ID \code{uid} can be supplied to retrieve a more specific subset of data. By default, \code{uid = NULL} and \code{stapi} operates in search mode.
#' As part of a stepwise process, you can first use search mode.
#' Then if the resulting data frame includes a \code{uid} column, you can make a second call to the function providing a specific \code{uid}.
#' This puts \code{stapi} into extraction mode and will return satellite data associated with the unique entry from the original general sweep of the entity \code{id}.
#'
#' @param id character, name of STAPI entity. See details.
#' @param page integer vector, defaults to first page.
#' @param uid \code{NULL} for search mode, character for extraction mode. See details.
#' @param page_count logical, set to \code{TRUE} to do a preliminary check of the total number a pages of results available for a potential entity search. This will only have the impact of searching the first page.
#'
#' @return a data frame in search mode, a list in extraction mode, and nothing is returned in page count check mode but the result is printed to the console.
#' @export
#'
#' @examples
#' library(dplyr)
#' stapi("character", page_count = TRUE) # check first
#' stapi("character", page = 2) %>% select(1:2)
#' Q <- stapi("character", uid = "CHMA0000025118")
#' Q$character$episodes %>% select(uid, title, stardateFrom, stardateTo)
stapi <- function(id, page = 1, uid = NULL, page_count = FALSE){
  if(!id %in% .stapi_entities) stop("Invalid `id`.")
  type <- if(is.null(uid)) "/search?pageNumber=" else paste0("?uid=", uid)
  uri <- paste0("http://stapi.co/api/v1/rest/", id, type)
  if(!is.null(uid)) return(jsonlite::fromJSON(uri))
  json0 <- jsonlite::fromJSON(paste0(uri, "0&pageSize=100"))
  total_pages <- json0$page$totalPages
  if(page_count){
    cat("Total pages to retrieve all results:", total_pages, "\n")
    return(invisible())
  }
  json0 <- jsonlite::flatten(json0[[3]], recursive = TRUE)
  if(total_pages != 1 && (length(page) != 1 || page != 1)){
    include_page1 <- 1 %in% page
    page <- page[page != 1]
    json <- purrr::map(page, ~jsonlite::flatten(
      jsonlite::fromJSON(paste0(uri, .x, "&pageSize=100"))[[3]], recursive = TRUE)
    )
    if(include_page1) json <- c(list(json0), json)
    d <- dplyr::bind_rows(json)
  } else {
    d <- json0
  }
  idx <- match(.stapi_dropcols, names(d))
  if(length(idx)) d <- dplyr::select(d, -idx)
  dplyr::tbl_df(d)
}

# nolint end
