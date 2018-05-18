#install.packages("hexSticker")
library(hexSticker)
library(memery)
pkg <- basename(getwd())
out <- paste0(c("data-raw/images/"), pkg, c(".png", "-small.png"))
sysfonts::font_add(family = "tng", "data-raw/Star Next.ttf")
meme("data-raw/images/ufp0.png", "R", "data-raw/images/hexsubplot.png", size = 13,
     label_pos = list(w = 1, h = 1, x = 0.43, y = 0.5), family = "tng", col = "#98F5FFDD", shadow = "transparent")

round(663*2400/2074) # Next stretch width to 767 pixels and resave as hexsubplot2.png, then continue with script.

hex_plot <- function(out, mult = 1){
  sticker("data-raw/images/hexsubplot2.png", 1, 1, 0.8, 0.8, "TREK", p_size = mult * 36, p_y = 1, p_color = "#63B8FFDD",
          p_family = "tng", h_size = mult * 1, h_fill = "#001030", h_color = "slategray1",
          url = paste0("leonawicz.github.io/", pkg), u_color = "slategray1", u_size = mult * 3, filename = out)
  # overwrite file for larger size
  if(mult != 1) ggplot2::ggsave(out, width = mult*43.9, height = mult*50.8, bg = "transparent", units = "mm")
}

# Both logo versions in data-raw; neither published inside package
hex_plot(out[1], 4) # multiplier for larger sticker size
hex_plot(out[2])
