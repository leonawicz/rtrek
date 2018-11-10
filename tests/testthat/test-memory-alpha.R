context("Memory Alpha")

test_that("memory_alpha returns as expected", {
  expect_identical(memory_alpha("portals"), .ma_portals)

  grp <- c("id", "url", "group", "subgroup")
  d <- memory_alpha("alternate")
  expect_equal(ncol(d), 4)
  expect_equal(names(d), grp)

  d <- memory_alpha("people")
  expect_equal(ncol(d), 3)
  expect_equal(names(d), grp[1:3])

  d <- memory_alpha("science")
  expect_equal(ncol(d), 3)
  expect_equal(names(d), grp[1:3])

  d <- memory_alpha("series")
  expect_equal(ncol(d), 3)
  expect_equal(names(d), grp[1:3])

  d <- memory_alpha("society")
  expect_equal(ncol(d), 3)
  expect_equal(names(d), grp[1:3])

  d <- memory_alpha("technology")
  expect_equal(ncol(d), 3)
  expect_equal(names(d), grp[1:3])

  d <- memory_alpha("series/Deep Space Nine")
  expect_equal(dim(d), c(1, 4))
  expect_equal(names(d), c("title", "content", "metadata", "categories"))
  expect_equal(as.character(sapply(d, class)), c("character", rep("list", 3)))
  expect_is(d$content[[1]], "xml_nodeset")

  d <- memory_alpha("people/Klingons")
  expect_equal(ncol(d), 2)
  expect_equal(names(d), c("Klingons", "url"))

  d <- memory_alpha("people/Klingons/Azetbur")
  expect_equal(dim(d), c(1, 4))
  expect_equal(names(d), c("title", "content", "metadata", "categories"))
  expect_equal(as.character(sapply(d, class)), c("character", rep("list", 3)))
  expect_is(d$content[[1]], "xml_nodeset")

  expect_error(memory_alpha("x"), "Invalid endpoint: portal ID.")
  expect_error(memory_alpha("people/Klingons/x"), "Invalid endpoint: x.")
  expect_error(memory_alpha("people/Klingons/Azetbur/x"),
               "Azetbur is an article but `endpoint` does not terminate here.")
})

test_that("ma_article returns as expected", {
  expect_error(ma_article("x"), "Article not found.")
  closeAllConnections()

  expect_equal(ncol(memory_alpha("people/Acamarians")), 2)
  expect_is(ma_article("Star_Trek")$metadata[[1]], "NULL")

  d0 <- memory_alpha("people/Klingons/Azetbur")
  d <- ma_article("Azetbur")
  expect_equal(unlist(d0), unlist(d))

  d <- ma_article("Azetbur", content_format = "character")
  expect_is(d$content[[1]], "character")
})

test_that("ma_search returns as expected", {
  d <- ma_search("Worf")
  expect_equal(ncol(d), 3)
  expect_equal(names(d), c("title", "text", "url"))
})
