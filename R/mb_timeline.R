#' Memory Beta timeline
#'
#' Access curated data frames containing Star Trek timeline data.
#'
#' The timeline data is from the
#' \href{https://memory-beta.fandom.com/wiki/Memory_Beta_Chronology}{Memory Beta Chronology}.
#'
#' `x` can be a numeric vector of years, e.g. `x = 2361:2364`. This should only
#' be used if you know (or can safely assume) a year exists as a page on Memory
#' Beta. Check there first if unsure. `x` may otherwise be scalar character.
#' This can be a specific decade in the form, e.g., `"2370s"`. If a decade, it
#' must fall in the range from `"1900s"` through `"2490s"`. The decade option
#' pulls back data from the decade page entry, or if individual year pages exist
#' within the given decade, it will pull the data for each existing year.
#'
#' Special values: For the more distant past or future, use the character
#' options `x = "past"` or `x = "future"`. `x = "main"` will pull from the main
#' part of the timeline, 1900 - 2499. `x = "complete"` combines past, main, and
#' future in order.
#'
#' The distant past and future have few entries, and thus few pages. However,
#' both of these last two options, `"main"` and `complete`, must download a
#' large number of pages. For this reason, `rtrek` employs anti-DOS measures to
#' prevent an unwitting user from making too many requests too quickly from
#' Memory Beta. The function would otherwise be far faster. However, to be a
#' friendly neighbor in the cosmos, `rtrek` enforces a minimum one-second wait
#' between timeline requests. This can lead to downloading the full timeline to
#' take ten minutes or so even if you have a fast connection; most of the time
#' it takes is spent waiting patiently.
#'
#' Also, like other functions that work with Memory Alpha and Memory Beta data,
#' `mb_timeline` wraps around internal functions that are sensibly memoized.
#' This means that if you make the same call twice in your R session, you won't
#' have to wait at all, because the result is cached in memory. The call will
#' appear to run instantaneously the second time around, but that's because
#' nothing is happening other than returning the cached result from the initial
#' call.
#'
#' @param x numeric or character, description of the desired timeline window.
#' See details.
#' @param html logical, set to `TRUE` to return the `details` text column of the
#' `Events` data frame as basic HTML character strings.
#'
#' @return a list of two data frames
#' @export
#'
#' @examples
#' \donttest{mb_timeline(2360)}
#' \dontrun{
#' mb_timeline("2360s")
#' mb_timeline("past")
#' mb_timeline("future")
#' mb_timeline("main")
#' mb_timeline("complete")
#' mb_timeline("complete", html = TRUE)
#' }
mb_timeline <- function(x, html = FALSE){
  if(is.numeric(x)){
    purrr::map(as.character(x), function(x) .mb_tl_list(x, as_html = html)) |>
      purrr::transpose() |>
      purrr::map(dplyr::bind_rows)
  } else {
    if(length(x) > 1){
      stop("`x` can only be a vector for numeric years. Charatcer options must be scalar.", call. = FALSE)
    }
    if(grepl("^\\d\\d\\d\\ds$", x)){
      if(x < "1900s" | x > "2490s")
        stop(paste("`x` must be in the range '1900s' - '2490s'.",
                   "For distant past or future use x = 'past' or x = 'future'."), call. = FALSE)
      mb_tl_by_decade_year(min = x, max = x, html = html)
    } else {
      if(!x %in% c("main", "past", "future", "complete"))
        stop(paste("`x` must be numeric years, e.g., 2371:2374, or character decade, e.g. '2370s',",
                    "or one of 'main', 'past', 'future' or 'complete'."), call. = FALSE)
      switch(x, main = mb_tl_by_decade_year(html = html),
             past = mb_tl_past(html = html),
             future = mb_tl_future(html = html),
             complete = mb_tl_complete(html = html))
    }
  }
}

mb_tl_complete <- function(html = FALSE){
  list(
    mb_tl_past(html = html),
    mb_tl_by_decade_year(html = html),
    mb_tl_future(html = html)
  ) |>
    purrr::transpose() |>
    purrr::map(dplyr::bind_rows)
}

mb_tl_past <- function(html = FALSE){
  distant_past <- c("Billions_of_years_ago", "Millions_of_years_ago", "Thousands_of_years_ago")
  x0 <- purrr::map(distant_past, .mb_tl_list, as_html = html) |>
    purrr::transpose() |>
    purrr::map(dplyr::bind_rows)

  recent_past <- mb_base_add("Memory_Beta_Chronology:_Recent_Past")
  x1 <- xml2::read_html(recent_past) |>
    rvest::html_nodes("body .page__main .mw-parser-output")
  recent_past2 <- x1 |> rvest::html_nodes(".mw-headline > a") |> mb_href()
  x1_events <- purrr::map(recent_past2, .mb_tl_list, as_html = html, stories = FALSE) |>
    purrr::transpose()
  x1_events <- dplyr::bind_rows(x1_events[[1]])

  tbls <- x1 |> rvest::html_nodes("table")
  tbls <- tbls[is.na(rvest::html_attr(tbls, "class"))]
  x1_stories <- purrr::map_dfr(seq_along(tbls), ~.mb_stories_df(tbls[.x]))
  x0$events <- dplyr::bind_rows(x0$events, x1_events)
  x0$stories <- dplyr::bind_rows(x0$stories, x1_stories)
  x0
}

mb_tl_past <- memoise::memoise(mb_tl_past)

mb_tl_future <- function(html = FALSE){
  x <- mb_base_add("Memory_Beta_Chronology:_Far_Future") |> xml2::read_html() |>
    rvest::html_nodes("body .page__main .mw-parser-output")
  x2 <- x |> rvest::html_nodes(".mw-headline > a") |> mb_href()
  events <- purrr::map(x2, .mb_tl_list, as_html = html, stories = FALSE) |> purrr::transpose()
  events <- dplyr::bind_rows(events[[1]])

  tbls <- x |> rvest::html_nodes("table")
  tbls <- tbls[is.na(rvest::html_attr(tbls, "class"))]
  stories <- purrr::map_dfr(seq_along(tbls), ~.mb_stories_df(tbls[.x]))
  list(events = events, stories = stories)
}

mb_tl_future <- memoise::memoise(mb_tl_future)

mb_tl_by_decade_year <- function(min = "1800s", max = "2490s", html = FALSE){
  decades <- memory_beta("timeline/Decades") |>
    dplyr::filter(.data[["url"]] != "Decade" & !grepl("^Category:", .data[["url"]]) &
                    .data[["url"]] >= min & .data[["url"]] <= max)
  pages <- purrr::map(decades$url, decade_year_pages) |> purrr::flatten()
  z = purrr::map(seq_along(pages), ~.mb_tl_list(pages[.x], as_html = html)) |>
    purrr::transpose() |> purrr::map(dplyr::bind_rows)
}

mb_tl_safe_read <- function(url){
  .antidos("mbtl")
  cat(url, "\n")
  x <- xml2::read_html(mb_base_add(url))
  assign("mbtl", Sys.time(), envir = rtrek_api_time)
  x
}

decade_year_pages <- function(url){
  x0 <- mb_tl_safe_read(url)
  x <- rvest::html_nodes(x0, "body .page__main .mw-parser-output")
  if(!length(rvest::html_nodes(x, "#Years"))){
    x0 <- list(x0)
    names(x0) <- url
    return(x0)
  }
  all_years <- as.character(as.integer(substr(url, 1, 4)) + 0:9)
  x <- rvest::html_nodes(x, "ul > li > a") |> mb_href()
  url <- intersect(x, all_years)
  x <- purrr::map(url, mb_tl_safe_read)
  names(x) <- url
  x
}

decade_year_pages <- memoise::memoise(decade_year_pages)

.mb_tl_list <- function(x, as_html = FALSE, stories = TRUE){
  if(inherits(x, "character")){
    url <- x
    x <- mb_tl_safe_read(url)
  } else {
    url <- names(x)
    x <- x[[1]]
  }
  period <- gsub("_", " ", url)

  x <- rvest::html_nodes(x, "body .page__main .mw-parser-output") |>
    rvest::html_nodes("h2, h3, h4, li, table")

  # Remove TOC section (and anything prior)
  idx <- grep("toclevel", rvest::html_attr(x, "class"), ignore.case = TRUE)
  if(length(idx)) x <- x[-c(1:max(idx))]
  # Remove external link section (and anything beyond)
  idx <- grep("External link", rvest::html_text(x), ignore.case = TRUE)
  if(length(idx)) x <- x[1:(idx - 1)]
  # Remove ref/note section
  idx <- grep("cite_note", rvest::html_attr(x, "id"), ignore.case = TRUE)
  if(length(idx)) x <- x[-idx]
  idx <- grep("cite_note", rvest::html_attr(x, "id"), ignore.case = TRUE)
  if(length(idx)) x <- x[-idx]
  # Remove some headings: 'References and notes', 'Appendices', 'Notable people'
  idx <- grep("^References|^Appendices|^Notable people", rvest::html_text(x), ignore.case = TRUE)
  if(length(idx)) x <- x[-idx]

  # Get text (used) and tag names (not current used)
  tag_names <- rvest::html_name(x)
  txt <- trimws(gsub("\\[(citation*|\\d+|)\\](\\[.*|)$", "", trimws(rvest::html_text(x))))

  # Separate from Stories section
  stories_idx <- grep("^Stories", txt)
  if(length(stories_idx)){
    tag_names <- tag_names[1:(stories_idx - 1)]
    txt <- txt[1:(stories_idx - 1)]
  }

  # Reconstruct basic HTML
  html <- paste0("<", tag_names, ">", txt, "</", tag_names, ">")
  ul_start <- tag_names == "li" & c("x", tag_names[-length(tag_names)]) != "li"
  ul_end <- tag_names == "li" & c(tag_names[-1], "x") != "li"
  html[ul_start] <- paste0("<ul>", html[ul_start])
  html[ul_end] <- paste0(html[ul_end], "</ul>")
  html <- paste(html, collapse = "\n")
  html <- gsub("<ul><li>", "<ul>\n<li>", html)
  html <- gsub("</li></ul>", "</li>\n</ul>", html)
  html <- strsplit(html, "\n")[[1]]
  html <- c(paste0("<div id='", period, "'>"), paste0("<h1>", period, "</h1>"), html, "</div>")

  d <- tibble::tibble(period = !!period, details = if(as_html) html else txt)
  d <- dplyr::filter(d, !grepl("^Year and events", .data[["details"]]))

  if(!length(stories_idx) || stories_idx + 1 > length(x)) stories <- FALSE
  if(stories){
    if(!rvest::html_name(x[[stories_idx + 1]]) == "table") stories <- FALSE
  }

  ds <- if(stories) .mb_stories_df(x[stories_idx + 1]) else NULL
  list(events = d, stories = ds)
}

.mb_tl_list <- memoise::memoise(.mb_tl_list)

.mb_fix_date_in_notes <- function(x){
  idx <- grep("^(\\d+: |^Circa \\d+: |\\d\\d\\d\\d )", x$notes)
  if(length(idx)){
    x$date[idx] <- gsub("^(\\d+|^Circa \\d+|\\d\\d\\d\\d)(: | ).*", "\\1", x$notes[idx])
    x$notes[idx] <- gsub("^(\\d+: |^Circa \\d+: |\\d\\d\\d\\d )(.*)", "\\2", x$notes[idx])
  }
  x
}

.mb_stories_df <- function(x){
  d0 <- x[[1]] |> rvest::html_table(header = TRUE, trim = TRUE)
  d1 <- .mb_stories_titles(x)
  d <- dplyr::bind_cols(d1, dplyr::select(d0, -1)) |>
    dplyr::mutate(Media = ifelse(.data[["Media"]] == "episodenovelization", "episode novelization", .data[["Media"]]),
                  Notes = ifelse(.data[["Notes"]] == "", as.character(NA), .data[["Notes"]]),
                  Image = .mb_stories_images(x))
  d <- dplyr::mutate_if(d, function(x) !is.character(x), as.character)
  names(d)[7:11] <- c("series", "date", "media", "notes", "image_url")
  d <- .mb_fix_date_in_notes(d)
  d
}

.mb_stories_titles <- function(x){
  title_nodes <- rvest::html_nodes(x, "tr")[-1]
  title_nodes <- purrr::map(title_nodes, ~rvest::html_nodes(.x, "td")[1])
  titles <- purrr::map(title_nodes, ~rvest::html_nodes(.x, "b > a"))
  title_lab <- purrr::map_chr(titles, ~{if(length(.x)) paste0(mb_text(.x), collapse = "; ") else as.character(NA)})
  title_url <- purrr::map_chr(titles, ~{if(length(.x)) paste0(mb_href(.x), collapse = "; ") else as.character(NA)})

  ms <- purrr::map(title_nodes, ~rvest::html_nodes(.x, "small > a"))
  ms_lab <- purrr::map_chr(ms, ~{if(length(.x)) paste0(mb_text(.x), collapse = "; ") else as.character(NA)})
  ms_url <- purrr::map_chr(ms, ~{if(length(.x)) paste0(mb_href(.x), collapse = "; ") else as.character(NA)})

  section <- purrr::map_chr(title_nodes, ~{
    x <- rvest::html_nodes(.x, "small") |> xml2::xml_contents()
    idx <- which(rvest::html_name(x) == "text")
    if(!length(idx)) return(as.character(NA))
    x <- x[idx]
    x <- x[grepl("[A-Za-z0-9]", mb_text(x))]
    if(!length(x)) return(as.character(NA))
    if(length(x) == 1) mb_text(x) else paste0(mb_text(x), collapse = "; ")
  })

  context <- purrr::map_chr(title_nodes, ~{
    x <- rvest::html_nodes(.x, "small small, small b") |> mb_text()
    ifelse(length(x), gsub("^\\(|\\)$", "", x), as.character(NA))
  })
  tibble::tibble(title = title_lab, title_url = title_url, colleciton = ms_lab, collection_url = ms_url,
                     section = section, context = context)
}

.mb_stories_images <- function(x){
  nodes <- rvest::html_nodes(x, "tr")[-1]
  purrr::map_chr(nodes, ~{
    x <- rvest::html_nodes(.x, "td")[6] |> rvest::html_nodes("a") |> mb_href()
    if(length(x)) x else return(as.character(NA))
    x <- strsplit(x, "/")[[1]]
    idx <- grep("\\.jpg", x, ignore.case = TRUE)
    if(!length(idx)) return(as.character(NA))
    paste0("File:", x[idx])
  })
}
