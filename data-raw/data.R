.STspecies <- c("Human", "Romulan", "Klingon", "Breen", "Ferengi", "Cardassian", "Tholian")

STgeo <- data.frame(
  x = c(2196, 2615, 3310, 1004, 1431, 1342, 407),
  y = c(2357, 1742, 3361, 939, 1996, 2841, 3866),
  label = c("Earth", "Romulus", "Qo'noS", "Breen", "Ferenginar", "Cardassia", "Tholia"),
  body = "Planet", category = "Homeworld",
  zone = c("United Federation of Planets", "Romulan Star Empire", "Klingon Empire", "Breen Confederacy",
           "Ferengi Alliance", "Cardassian Union", "Tholian Assembly"),
  species = .STspecies)

STspecies <- data.frame(
  species = .STspecies,
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

usethis::use_data(STgeo, STspecies)
