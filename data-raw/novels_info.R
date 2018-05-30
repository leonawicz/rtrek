# scrape Wikipedia novels page
library(dplyr)
library(rvest)
url <- "https://en.wikipedia.org/wiki/List_of_Star_Trek_novels"
x <- url %>%  read_html %>%  html_nodes("h2,h3,h4,table")
start <- grep("<h2>\n<span id=", x)[1]
end <- grep("id=\"Original_audio\"", x) - 1
x <- x[start:end]

x <- x %>% purrr::map(~({
  if(html_name(.x) == "table"){
    d <- tbl_df(html_table(.x, fill = TRUE))
    if("Set" %in% names(d)) d <- rename(d, Timeframe = Set)
    if("Timeframe" %in% names(d)) d <- mutate(d, Timeframe = as.character(Timeframe))
    if("Released" %in% names(d)) d <- mutate(d, Released = as.character(Released))
    if("Contributor" %in% names(d) & !"Author" %in% names(d)) d <- rename(d, Author = Contributor)
    if("No." %in% names(d)){
      d <- rename(d, Number = No.) %>% mutate(Number = as.integer(ifelse(Number == "", NA, Number)))
    }
    if("English title" %in% names(d)){
      d <- rename(d, Title = `English title`, Released = `Released (English)`) %>%
        select(-`Original German title`, -`Originally Released (German)`)
    }
    d <- mutate(d, Title = gsub("†", "", Title))
    mutate_if(d, is.character, trimws)
  } else {
    data_frame(heading = html_name(.x), Series = gsub("\\[edit\\]", "", html_text(.x)),
               id = html_nodes(.x, "span") %>% html_attr("id") %>% na.omit() %>% `[`(1)) %>%
      mutate_if(is.character, trimws)
  }
})
)

# collapse prior heading entry
tbl_idx <- which(purrr::map(x, ~!"heading" %in% names(.x)) == TRUE)

x[tbl_idx] <- purrr::map(tbl_idx, ~({
  d1 <- x[[.x - 1]]
  d2 <- x[[.x]]
  d2 <- mutate(d2, heading = d1$heading, id = d1$id)
  if(!"Series" %in% names(d2)) mutate(d2, Series = d1$Series) else mutate(d2, Series = paste0(d1$Series, " (", Series, ")"))
})
)
x <- x[-c(tbl_idx - 1)]

# collapse level 3 entries (interactive)
lev <- purrr::map_dbl(x, ~switch(unique(.x$heading), "h2" = 1, "h3" = 2, "h4" = 3))
which(lev == 3)
x[[3]] <- bind_rows(x[3:5])
x[[22]] <- bind_rows(x[22:27])
x <- x[-c(4:5, 23:27)]

# empty level 2 entries
lev <- purrr::map_dbl(x, ~switch(unique(.x$heading), "h2" = 1, "h3" = 2, "h4" = 3))
idx <- which(purrr::map_lgl(x, ~nrow(.x) == 1 & ncol(.x) == 3 & names(.x)[1] == "heading" & .x$heading[1] == "h3") == TRUE)
x <- x[-idx]

# drop any remaining 3-column entries
x <- x[purrr::map_lgl(x, ~ncol(.x) != 3)]

# interactive adjustments
x[[1]]$Series <- paste0("The_Original_Series - Bantam_", x[[1]]$Series)
for(i in 2:6) x[[i]]$Series <- paste0("The_Original_Series - ", x[[i]]$Series)
x[[31]] <- slice(x[[31]], -1) %>% mutate(Series = paste0("TNG Starfleet Academy - ", Series))
x <- bind_rows(x) %>% select(Series, Title, Author, Number, Timeframe, Released, id) %>%
  mutate(Released = gsub("^[0]+|-0000", "", Released))

stBooksId <- distinct(x, id) %>% slice(-c(2:8, 21:29)) %>%
  mutate(
    series = c("THe Original Series", "The Next Generation", "Deep Space Nine", "Voyager", "Enterprise", "Discovery",
               "New Frontier", "Stargazer", "IKS Gorkon/Klingon Empire", "Titan", "Vanguard", "Seekers", "Mini-series",
               "Starfleet Corps of Engineers", "Department of Temporal Investigations", "Mirror Universe",
               "Starfleet Academy"),
    abb = c("TOS", "TNG", "DS9", "VOY", "ENT", "DSC", "NF", "SG", "IKE", "TIT", "VAN", "SKR", "miniseries", "SCE", "DTI", "MIR", "SFA")
  )
stBooks <- select(x, -id)

saveRDS(stBooksId, "data-raw/internal/stBooksId.rds")
usethis::use_data(stBooks)
