context("datasets")

test_that("dataset list returns as expected", {
  expect_equal(st_datasets(), c("STgeo", "STspecies"))
})
