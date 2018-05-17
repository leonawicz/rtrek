context("datasets")

d <- st_datasets()

test_that("dataset list returns as expected", {
  expect_is(d, "data.frame")
  expect_equal(dim(d), c(4, 2))
})

d <- st_book_series()

test_that("st_book_series returns as expected", {
  expect_is(d, "data.frame")
  expect_equal(dim(d), c(17, 2))

  skip_on_cran()
  skip_on_travis()
  expect_is(st_book_series("DS9"), "NULL")
})
