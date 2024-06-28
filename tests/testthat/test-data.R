d <- st_datasets()

test_that("dataset list returns as expected", {
  expect_is(d, "data.frame")
  expect_equal(dim(d), c(10, 2))
})

test_that("st_books_wiki returns as expected", {
  skip_on_cran()
  skip_on_os(c("linux", "mac"))
  expect_is(st_books_wiki(), "NULL")
})
