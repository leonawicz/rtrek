mb_timeline <- function(){
  distant_past <- c("Billions_of_years_ago", "Millions_of_years_ago", "Thousands_of_years_ago")
  x0 <- purrr::map(distant_past, .mb_tl_list) %>% purrr::transpose() %>% purrr::map(dplyr::bind_rows)

  recent_past <- mb_base_add("Memory_Beta_Chronology:_Recent_Past")
  x1 <- xml2::read_html(recent_past) %>%
    rvest::html_nodes(".WikiaMainContent > .WikiaMainContentContainer > .WikiaArticle > #mw-content-text")
  recent_past2 <- x1 %>% rvest::html_nodes(".mw-headline > a") %>% mb_href()
  x1_events <- purrr::map(recent_past2, .mb_tl_list, stories = FALSE) %>% purrr::transpose() %>% `[[`(1) %>%
    dplyr::bind_rows()

  tbls <- x1 %>% rvest::html_nodes("table")
  tbls <- tbls[is.na(rvest::html_attr(tbls, "class"))]
  x1_stories <- purrr::map_dfr(seq_along(tbls), ~.mb_stories_df(tbls[.x]))
  x0$events <- dplyr::bind_rows(x0$events, x1_events)
  x0$stories <- dplyr::bind_rows(x0$stories, x1_stories)
  x0
}

.mb_tl_list <- function(url, stories = TRUE){
  x <- xml2::read_html(mb_base_add(url)) %>%
    rvest::html_nodes(".WikiaMainContent > .WikiaMainContentContainer > .WikiaArticle > #mw-content-text") %>%
    rvest::html_nodes(".mw-headline, dt, dd, li, table")
  ids <- rvest::html_attr(x, "id")
  idx <- grep("^External_link", ids)
  if(length(idx)){
    x <- x[1:(idx - 1)]
    ids <- ids[1:(idx - 1)]
  }

  x <- x[is.na(ids) | !grepl("^cite|^Connections|^Appendices|^References|^External|^toc$", ids)]
  ids <- rvest::html_attr(x, "id")
  idx <- which(is.na(ids))
  d <- tibble::data_frame(period = gsub("_", " ", url), id = ids) %>%
    tidyr::fill(!!"id") %>% dplyr::slice(idx)
  x <- x[idx]
  ids <- rvest::html_name(x)

  txt <- purrr::map_chr(seq_along(x), ~ifelse(ids[.x] == "dt", mb_text(x[.x]), as.character(NA)))
  idx <- which(is.na(txt))
  d <- dplyr::mutate(d, date = txt) %>% tidyr::fill(!!"date") %>% dplyr::slice(idx)
  d$date[d$id == "Stories"] <- NA
  x <- x[idx]

  d <- dplyr::mutate(d, node = purrr::map(seq_along(x), ~x[.x]))
  if(stories) ds <- dplyr::filter(d, .data[["id"]] == "Stories")
  d <- dplyr::filter(d, .data[["id"]] != "Stories")

  d$notes <- sapply(d$node, mb_text)
  d <- dplyr::select(d, -.data[["node"]]) %>% dplyr::filter(.data[["notes"]] != "")
  d <- .mb_fix_date_in_notes(d)
  if(nrow(d) == 0) d <- NULL
  ds <- if(stories) .mb_stories_df(ds$node[[1]]) else NULL
  list(events = d, stories = ds)
}

.mb_fix_date_in_notes <- function(x){
  idx <- grep("^(\\d+: |^Circa \\d+: )", x$notes)
  if(length(idx)){
    x$date[idx] <- gsub("^(\\d+|^Circa \\d+): .*", "\\1", x$notes[idx])
    x$notes[idx] <- gsub("^(\\d+: |^Circa \\d+: )(.*)", "\\2", x$notes[idx])
  }
  x
}

.mb_stories_df <- function(x){
  d0 <- x[[1]] %>% rvest::html_table(header = TRUE, trim = TRUE)
  d1 <- .mb_stories_titles(x)
  d <- dplyr::bind_cols(d1, dplyr::select(d0, -1)) %>%
    dplyr::mutate(Media = ifelse(.data[["Media"]] == "episodenovelization", "episode novelization", .data[["Media"]]),
                  Notes = ifelse(.data[["Notes"]] == "", as.character(NA), .data[["Notes"]]),
                  Image = .mb_stories_images(x))
  d <- dplyr::mutate_if(d, function(x) !is.character(x), as.character)
  names(d)[7:11] <- c("series", "date", "media", "notes", "image_url")
  d
}

.mb_stories_titles <- function(x){
  title_nodes <- rvest::html_nodes(x, "tr") %>% `[`(-1) %>% purrr::map(~rvest::html_nodes(.x, "td")[1])
  titles <- purrr::map(title_nodes, ~rvest::html_nodes(.x, "b > a"))
  title_lab <- purrr::map_chr(titles, ~{if(length(.x)) mb_text(.x) else as.character(NA)})
  title_url <- purrr::map_chr(titles, ~{if(length(.x)) mb_href(.x) else as.character(NA)})

  ms <- purrr::map(title_nodes, ~rvest::html_nodes(.x, "small > a"))
  ms_lab <- purrr::map_chr(ms, ~{if(length(.x)) mb_text(.x) else as.character(NA)})
  ms_url <- purrr::map_chr(ms, ~{if(length(.x)) mb_href(.x) else as.character(NA)})

  section <- purrr::map_chr(title_nodes, ~{
    x <- rvest::html_nodes(.x, "small") %>% xml2::xml_contents()
    idx <- which(rvest::html_name(x) == "text")
    if(length(idx)) x <- mb_text(x[idx]) else return(as.character(NA))
    x <- x[!x %in% c("(", ")")]
    if(!length(x)) x <- as.character(NA)
    x
  })

  context <- purrr::map_chr(title_nodes, ~{
    x <- rvest::html_nodes(.x, "small > b") %>% mb_text()
    ifelse(length(x), x, as.character(NA))
  })
  tibble::data_frame(title = title_lab, title_url = title_url, colleciton = ms_lab, collection_url = ms_url,
                     section = section, context = context)
}

.mb_stories_images <- function(x){
  rvest::html_nodes(x, "tr") %>% `[`(-1) %>% purrr::map_chr(~{
    x <- rvest::html_nodes(.x, "td")[6] %>% rvest::html_nodes("a") %>% mb_href()
    if(length(x)) x else return(as.character(NA))
    x <- strsplit(x, "/")[[1]]
    idx <- grep("\\.jpg", x, ignore.case = TRUE)
    if(!length(idx)) return(as.character(NA))
    paste0("File:", x[idx])
  })
}
