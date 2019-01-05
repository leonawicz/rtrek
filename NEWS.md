# rtrek 0.2.0

* Added an initial version of an API function `memory_alpha` along with a collection of internal support functions for accessing Star Trek data from web portals available on the Memory Alpha website.
    * Internal portal functions that return data from portal and portal category web pages, and which may run recursively when necessary to compile complete content over multiple pages, are memoized. 
    * Functions like `ma_article`, which return article content from a terminal endpoint are not memoized.
* Added `ma_search` function for using the Memory Alpha site search via URL parameters.
* Added `ma_image` function for downloading source images from Memory Alpha and loading into R as ggplot objects.
* Added an initial version of an API function `memory_beta` and other `mb_*` Memory Beta analogs to Memory Alpha website functions.
* Added `mb_timeline` for working with data from the Memory Beta Chronology.
* Added new datasets, mainly to timelines: `tlBooks`, `tlEvents`, `tlFootnotes`. Also added `stSeries` names and abbreviations table.
* Renamed `st_book_series` and `stBooksWP` to `st_books_wiki` and `stBooksWiki`, respectively.
* Updated tile set URLs.
* Updated `stBooks` dataset. This data frame now has better formatting, greater consistency, duplicates removed, and contains more entries than before. It is still incomplete and imperfect, but much improved over the previous version.
* Updated `stBooksWiki` dataset. Updated column names for consistency.
* Updates the acronyms used in the package for consistency.
* Update unit tests, added unit tests for Memory Alpha  and Memory Beta functions.
* Updated function documentation.
* Updated introduction vignette sections. Added new section relating to timeline datasets.
* Added three new vignettes for each of the three API options: STAPI, Memory Alpha, and Memory Beta.
* Minor bug fixes.

# rtrek 0.1.0

* Refactored some functions and datasets.
* Added new `stBooks` dataset, renamed previous `stBooks` to `stBooksWP`.
* Added connection to new map tile set, `galaxy2`.
* Add two more species/homeworlds to example data.
* Updated documentation.
* Added and updated unit tests.

# rtrek 0.0.9

* Remove remote `trekfont` now that it is available on CRAN.
* Prepare GitHub accessible external datasets that serve package web pages.
* Updated documentation, website. Add to "fun pages" (R & R), which are only part of website "vignettes", not package vignettes.
* Minor fixes.

# rtrek 0.0.8

* Added more robust testing of API entity searches.
* Minor refactor of `stapi` internals and addition of `stapiEntities` dataset.
* Added optional (non-dependent) association with `trekfont` package with a function `st_font` to list and preview fonts from that package.
* Updated documentation.
* Minor fixes.

# rtrek 0.0.7

* Added additional vignettes.
* Optional integration with `trekfont` package.
* Improved website, including initial version of Stellar Cartography page.
* Update data.
* Minor fixes.
* Updated readme and docs.

# rtrek 0.0.6

* Added initial introduction vignette content.
* Added anti-DDOS measures for API calls.
* Minor fixes.
* Updated unit tests.
* Updated readme.

# rtrek 0.0.5

* Added initial Star Trek data API functionality via STAPI wrapper.
* Updated documentation.
* Added unit tests.
* Added moderately curated data frame of Star Trek novels metadata scraped from Wikipedia.
* Added convenience function for accessing specific Wikipedia entries in browser.

# rtrek 0.0.1

* Added minimal data and functions.
* Added basic unit tests.
* Updated documentation, improved dataset and object curation.

# rtrek 0.0.0.9000

* Added initial package scaffolding.
