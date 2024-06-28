test_that("st_font returns as expected when optional packages are installed", {
  skip_on_cran()
  skip_on_os(c("linux", "mac"))

  x <- st_font()
  expect_is(x, "character")
  expect_equal(length(x), 107)
  x <- st_font("Federation")
  expect_is(x, c("gg", "ggplot"))
})
