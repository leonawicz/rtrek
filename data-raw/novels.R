library(dplyr)
library(trekdata)

files <- list.files("data-raw/support_files", pattern = ".epub$", recursive = TRUE, full.names = TRUE)
n <- 30
epubs <- split(files, cut(seq_along(files), breaks = n))
d <- vector("list", n)

system.time({
  for(i in 1:n){
    print(i)
    d[[i]] <- st_epub(epubs[[i]])
  }
})

drop_subseries_labels <- c("Captain's Table", "DTI", "Mirror Universe", "Myriad Universes",
                           "Strange New Worlds", "Young Adult Series")

d <- bind_rows(d) |> select(c(1:3, 5:4, 6, 12, 10, 13, 7, 11, 8)) |>
  mutate(identifier = gsub("-", "", identifier),
         subseries = ifelse(subseries %in% drop_subseries_labels, NA, subseries)) |>
  arrange(series_abb, subseries, date) |> rename(series = series_abb)
saveRDS(d, "data-raw/book.rds", version = 3)

f <- function(x) if(all(is.na(x))) as.character(NA) else paste0(as.character(na.omit(x)), collapse = " ")
d_sum <- tidyr::unnest(d) |>
  filter(!grepl("Contents|This\\sbook", substr(text, 1, 20))) |>
  group_by(title, author, date, publisher, identifier, file, series, subseries, nchap) |>
  summarise(nword = sum(nword), nchar = sum(nchar), dedication = f(dedication)) |>
  ungroup |> arrange(series, date) |> select(-file)
saveRDS(d_sum, "data-raw/book_metadata.rds", version = 3)

stBooks <- readRDS("data-raw/book_metadata.rds")
usethis::use_data(stBooks)
