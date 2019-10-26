context("datasets")

d <- st_datasets()

test_that("dataset list returns as expected", {
  expect_is(d, "data.frame")
  expect_equal(dim(d), c(11, 2))
})

d <- st_books_wiki()

test_that("st_books_wiki returns as expected", {
  expect_is(d, "data.frame")
  expect_equal(dim(d), c(19, 2))

  skip_on_cran()
  skip_on_travis()
  expect_is(st_books_wiki("DS9"), "NULL")
})
