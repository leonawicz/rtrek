context("datasets")

d <- st_datasets()

test_that("dataset list returns as expected", {
  expect_is(d, "data.frame")
  expect_equal(dim(d), c(3, 2))
})
