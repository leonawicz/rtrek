library(dplyr)

# minor package datasets
.st_species <- c("Human", "Romulan", "Klingon", "Breen", "Ferengi", "Cardassian", "Tholian", "Tzenkethi", "Talarian")
.st_locs <- c("Earth", "Romulus", "Qo'noS", "Breen", "Ferenginar", "Cardassia", "Tholia", "Tzenketh", "Talar")
.st_zone <- c("United Federation of Planets", "Romulan Star Empire", "Klingon Empire", "Breen Confederacy",
              "Ferengi Alliance", "Cardassian Union", "Tholian Assembly", "Tzenkethi Coalition", "Talarian Republic")
.tile_ids <- c("galaxy1", "galaxy2")

.gc01 <- data_frame(
  id = .tile_ids[1],
  loc = .st_locs,
  col = c(2196, 2615, 3310, 1004, 1431, 1342, 407, 1553, 1039),
  row = c(2357, 1742, 3361, 939, 1996, 2841, 3866, 2557, 3489)
)
.gc02 <- data_frame(
  id = .tile_ids[2],
  loc = .st_locs,
  col = c(2201, 2514, 3197, 1228, 2026, 1543, 713,  1734, 1338),
  row = c(1595, 1178, 2303, 1181, 886,  1903, 2971, 1721, 2368)
)
stGeo <- bind_rows(.gc01, .gc02)

stSpecies <- data_frame(
  species = .st_species,
  avatar = c(paste0("https://vignette.wikia.nocookie.net/memoryalpha/images/", c(
    "7/77/Hoshi_Sato%2C_2154.jpg/revision/latest/scale-to-width-down/350?cb=20120409224834",
    "2/25/Toreth.jpg/revision/latest/scale-to-width-down/292?cb=20140713231352",
    "c/c6/Martok%2C_Chancellor_of_the_Klingon_High_Council.jpg/revision/latest/scale-to-width-down/292?cb=20110805121635",
    "0/07/Pran.jpg/revision/latest/scale-to-width-down/292?cb=20060128135314",
    "2/28/Quark%2C_2375.jpg/revision/latest/scale-to-width-down/350?cb=20120329231622",
    "7/79/Dukat%2C_2375.jpg/revision/latest/scale-to-width-down/350?cb=20120418042102",
    "4/48/Tholian%2C_2155.jpg/revision/latest/scale-to-width-down/292?cb=20110905051618",
    "b/bc/Endar.jpg/revision/latest?cb=20140207112627"
  ), "&path-prefix=en"),
  "https://pwimages-a.akamaihd.net/arc/b1/c9/b1c942a7297c22abf5e375a9f60217681505520656.jpg")
)

stTiles <- data_frame(
  id = .tile_ids,
  url = paste0("https://leonawicz.github.io/tiles/", c("st1", "st2"), "/tiles/{z}/{x}/{y}.png"),
  description = rep("Geopolitical galaxy map", 2),
  width = c(8000, 5000),
  height = c(6445, 4000),
  tile_creator = rep("Matthew Leonawicz", 2),
  map_creator = c("Rob Archer", NA),
  map_url = c(
    "https://archerxx.deviantart.com/art/Star-Trek-Star-Chart-316982311",
    "http://sttff.net/AST_MAP.html"
  )
)

# create table of STAPI entity info
entities <- sort(c(
  "company", "comicStrip", "organization", "soundtrack", "character",
  "literature", "magazine", "videoRelease", "animal", "comicCollection", "staff",
  "title", "astronomicalObject", "element", "tradingCard",
  "comics", "tradingCardDeck", "magazineSeries", "videoGame", "technology", "comicSeries",
  "movie", "performer", "weapon", "episode", "season", "bookSeries", "conflict", "location",
  "spacecraftClass", "material", "species", "occupation", "bookCollection", "medicalCondition",
  "food", "tradingCardSet", "book", "spacecraft", "series"
))

dropcols <- c(
  paste0("title", c("Bulgarian", "Catalan", "ChineseTraditional", "German",
                    "Italian", "Japanese", "Polish", "Russian", "Serbian", "Spanish"))
)

library(purrr)
x <- vector("list", length(entities))
names(x) <- entities
for(i in seq_along(x)){
  print(paste("Attempting", entities[i]))
  x[[i]] <- stapi(entities[i])
}

all(map_chr(x, ~class(.x)[1]) == "tbl_df") # check all are data frames
all(map_lgl(x, ~"uid" %in% names(.x))) # check all have uid column

stapiEntities <- data_frame(
  id = entities, class = map_chr(x, ~class(.x)[1]), ncol = map_int(x, ncol), colnames = map(x, names)
)
attr(stapiEntities, "ignored columns") <- dropcols

# save datasets
usethis::use_data(stGeo, stSpecies, stTiles, stapiEntities)

# internal data
library(jpeg)
.worf <- readJPEG("data-raw/images/worf.jpg")

stBooksId <- readRDS("data-raw/internal/stBooksId.rds")

usethis::use_data(stBooksId, .worf, .st_species, .st_zone, internal = TRUE)

series_abb <- c("AV", "CHA", "DS9", "DSC", "ENT", "KE", "MISC", "NF", "PRO", "SKR", "SV",
                "SCE", "SGZ", "ST", "TAS", "TLE", "TNG", "TOS", "TTN","VAN", "VOY")
series <- c("Abramsverse", "Challenger", "Deep Space Nine", "Discovery", "Enterprise",
            "Klingon Empire", "Miscellaneous", "New Frontier", "Prometheus", "Seekers", "Shatnerverse",
            "Starfleet Corps of Engineers", "Stargazer", "All-Series/Crossover",
            "The Animated Series", "The Lost Era", "The Next Generation",
            "The Original Series", "Titan", "Vanguard", "Voyager")
anth_abb <- c("CON", "DS", "EL", "NL", "PAC", "SNW", "CT", "TLOD", "TNV", "TNV2", "TODW", "WLB", "YA")
anth <- c(
  c("Constellations", "Distant Shores", "Enterprise Logs", "New Frontier: No Limits",
    "Deep Space Nine: Prophecy and Change", "Strange New Worlds", "Tales from the Captain's Table",
    "The Lives of Dax", "The New Voyages", "The New Voyages 2", "Tales of the Dominion War",
    "Gateways: What Lay Beyond"), "Young Adult Book")
other_abb <- c("REF")
other <- c("Reference")
stSeries <- data_frame(
  id = c(series, anth, other),
  abb = c(series_abb, anth_abb, other_abb),
  type = rep(c("series", "anthology", "other"), times = c(length(series), length(anth), length(other)))
)

usethis::use_data(stSeries)
