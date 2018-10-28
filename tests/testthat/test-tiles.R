context("tiles")

test_that("tile_coords returns as expected", {
  d <- data.frame(row = c(0, 3222, 6445), col = c(0, 4000, 8000))
  xy <- tile_coords(d, "galaxy1")
  expect_is(xy, "data.frame")
  expect_equal(dim(xy), dim(d) + c(0, 2))

  d2 <- data.frame(row = 0, col = 0, x = 1)
  expect_error(tile_coords(d2, "galaxy1"), "`data` cannot contain columns named `x` or `y`")
  expect_error(tile_coords(d2[, 2:3], "galaxy1"), "`data` must contain columns named `col` and `row`")
})

test_that("st_tiles returns as expected", {
  expect_equal(st_tiles("galaxy1"), "https://leonawicz.github.io/tiles/st1/tiles/{z}/{x}/{y}.png")
})

test_that("st_tiles_data returns as expected", {
  expect_is(st_tiles_data("galaxy1"), "tbl_df")
})
