context("api")

library(dplyr)
qid <- "CHMA0000025118"

test_that("st_book_series returns as expected", {
  expect_is(stapi("character", page_count = TRUE), "NULL")

  d <- stapi("character", page = 2)
  d2 <- stapi("character", page = c(2, 4))
  d3 <- stapi("character", page = 1)
  d4 <- stapi("character", page = 1:2)
  dl <- list(d, d2, d3, d4)
  purrr::walk(dl, ~expect_is(.x, "tbl_df"))
  purrr::walk(dl, c(100, 200, 100, 200), ~expect_equal(nrow(.x), .y))

  Q <- stapi("character", uid = qid)
  expect_is(Q, "list")
  expect_equal(Q$name, "Q")

  expect_error(stapi("a"), "Invalid `id`.")

  expect_is(stapiEntities, "tbl_df")
  expect_is(attr(stapiEntities, "ignored columns"), "character")
})

test_that("rtrek_antiddos option is set on load and checked", {
  expect_equal(getOption("rtrek_antiddos"), 1)
  options(rtrek_antiddos = 0)
  wrn <- "`rtrek_antiddos` setting in `options` is less than one and will be ignored.\n"
  expect_warning(stapi("character", page = 2), wrn)
  options(rtrek_antiddos = 5) # trigger Sys.sleep
  x <- purrr::map(1:2, stapi("character", uid = qid))
  expect_identical(x[[1]], x[[2]])
  options(rtrek_antiddos = 1)
})

# local testing only
test_that("STAPI entity information has not substantially changed", {
  # always skip this test in remote testing
  skip_on_appveyor()
  skip_on_travis()
  skip_on_cran()

  # comment out this line to run local test; does not need to be run every time
  skip("This test is only run locally and does not need to be run often.")

  x <- purrr::map(stapiEntities$id, stapi)
  expect_true(all(purrr::map_chr(x, ~class(.x)[1]) == "tbl_df"))
  expect_true(all(purrr::map_lgl(x, ~"uid" %in% names(.x))))
})
