context("api")

unavail <- "Internet resources currently unavailable."
soc <- !has_internet("http://stapi.co")

library(dplyr)
qid <- "CHMA0000025118"

test_that("stapi returns as expected", {
  if(soc) skip(unavail)
  expect_is(stapi("character", page_count = TRUE), "NULL")

  d <- stapi("character", page = 2)
  d2 <- stapi("character", page = c(2, 4))
  d3 <- stapi("character", page = 1)
  d4 <- stapi("character", page = 1:2)
  dl <- list(d, d2, d3, d4)
  for(i in dl) expect_is(i, "tbl_df")
  for(i in seq_along(dl)) expect_equal(nrow(dl[[i]]), c(100, 200, 100, 200)[i])

  Q <- stapi("character", uid = qid)
  expect_is(Q, "list")
  expect_equal(Q$name, "Q")

  expect_error(stapi("a"), "Invalid `id`.")

  expect_is(stapiEntities, "tbl_df")
  expect_is(attr(stapiEntities, "ignored columns"), "character")
})

test_that("rtrek_antidos option is set on load and checked", {
  if(soc) skip(unavail)
  expect_equal(getOption("rtrek_antidos"), 1)
  options(rtrek_antidos = 0)
  wrn <- "`rtrek_antidos` setting in `options` is less than one and will be ignored.\n"
  expect_warning(stapi("character", page = 2), wrn)
  options(rtrek_antidos = 5) # trigger Sys.sleep
  x <- lapply(1:2, function(x) stapi("character", uid = qid))
  expect_identical(x[[1]], x[[2]])
  options(rtrek_antidos = 1)
})

# local testing only
test_that("STAPI entity information has not substantially changed", {
  # always skip this test in remote testing
  skip_on_appveyor()
  skip_on_travis()
  skip_on_cran()

  # comment out this line to run local test; does not need to be run every time
  skip("This test is only run locally and does not need to be run often.")

  x <- lapply(stapiEntities$id, stapi)
  expect_true(all(sapply(x, function(x) class(x)[1] == "tbl_df")))
  expect_true(all(sapply(x, function(x) "uid" %in% names(x))))
})
