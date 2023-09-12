test_that("st_transcripts imports successfully", {
  skip_on_cran()
  x <- st_transcripts()
  expect_equal(dim(x), c(726, 10))
})
