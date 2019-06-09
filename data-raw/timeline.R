library(trekdata)
library(dplyr)

file <- "data-raw/support_files/Reference/20061114 REF - Voyages of Imagination.epub"
x <- epubr::epub(file)
txt <- slice(x$data[[1]], match(c("bm_2", "bm_2a", "bm_2b"), x$data[[1]]$section))$text
txt <- paste0(txt, collapse = "\n")
txt <- strsplit(txt, "\n")[[1]] %>% tl_clean_text()

tlBookNotes <- tl_footnotes(txt)
tlBooks <- tl_entries(txt) %>% bind_rows()

tlEvents <- readr::read_csv("data-raw/st-timeline-2.csv")
idx <- which(!is.na(tlEvents$note))
tlEventNotes <- tibble(id = seq_along(idx), text = tlEvents$note[idx])
tlEvents$note <- as.integer(NA)
tlEvents$note[idx] <- seq_along(idx)
tlEvents <- rename(tlEvents, year = date, footnote = note) %>% select(c(1:3, 6:4))

tlFootnotes <- bind_rows(book = tlBookNotes, event = tlEventNotes, .id = "id")

usethis::use_data(tlBooks, tlEvents, tlFootnotes)
