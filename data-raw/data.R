library(dplyr)
.species <- c("Human", "Romulan", "Klingon", "Breen", "Ferengi", "Cardassian", "Tholian")

stGeo <- data_frame(
  col = c(2196, 2615, 3310, 1004, 1431, 1342, 407),
  row = c(2357, 1742, 3361, 939, 1996, 2841, 3866),
  label = c("Earth", "Romulus", "Qo'noS", "Breen", "Ferenginar", "Cardassia", "Tholia"),
  body = "Planet", category = "Homeworld",
  zone = c("United Federation of Planets", "Romulan Star Empire", "Klingon Empire", "Breen Confederacy",
           "Ferengi Alliance", "Cardassian Union", "Tholian Assembly"),
  species = .species)

stSpecies <- data_frame(
  species = .species,
  avatar = paste0("https://vignette.wikia.nocookie.net/memoryalpha/images/", c(
    "7/77/Hoshi_Sato%2C_2154.jpg/revision/latest/scale-to-width-down/350?cb=20120409224834",
    "2/25/Toreth.jpg/revision/latest/scale-to-width-down/292?cb=20140713231352",
    "c/c6/Martok%2C_Chancellor_of_the_Klingon_High_Council.jpg/revision/latest/scale-to-width-down/292?cb=20110805121635",
    "0/07/Pran.jpg/revision/latest/scale-to-width-down/292?cb=20060128135314",
    "2/28/Quark%2C_2375.jpg/revision/latest/scale-to-width-down/350?cb=20120329231622",
    "7/79/Dukat%2C_2375.jpg/revision/latest/scale-to-width-down/350?cb=20120418042102",
    "4/48/Tholian%2C_2155.jpg/revision/latest/scale-to-width-down/292?cb=20110905051618"
  ), "&path-prefix=en")
)

stTiles <- data_frame(
  id = "galaxy1",
  url = "https://leonawicz.github.io/tiles/data/st1/{z}/{x}/{y}.png",
  description = "Geopolitical galaxy map",
  width = 8000,
  height = 6445,
  tile_creator = "Matthew Leonawicz",
  map_creator = "Rob Archer",
  map_url = "https://archerxx.deviantart.com/art/Star-Trek-Star-Chart-316982311"
)

usethis::use_data(stGeo, stSpecies, stTiles, overwite = T)
