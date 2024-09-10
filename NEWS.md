# rtrek 0.5.1

* Documentation and other minor updates.

# rtrek 0.5.0

* Parser improvements.
* Bug fixes.
* Updated documentation and tests.

# rtrek 0.4.0

* API updates and bug fixes.
* Added required package alias in documentation.
* Removed package website content that is no longer maintained/references external content that is no longer available.
* Reduced data dependencies in `data-raw`.
* General documentation updates.

# rtrek 0.3.3

* Minor bug fix and documentation updates.

# rtrek 0.3.2

* Bug fixes related to website HTML updates.
* Updated unit tests.

# rtrek 0.3.1

* Tentative fix for bug related to galaxy map 2.

# rtrek 0.3.0

* Fix bugs related to Memory Alpha and Memory Beta breaking changes.
* Simplify Wikipedia book list function to reduce package maintenance. Encourage use of `stBooks`.
* Updated documentation and testing conditions.
* only build vignette for website, no longer included in package.

# rtrek 0.2.5

* Added `st_transcripts()` for importing datasets based on episode and movie transcripts containing metadata and variables for analysis of scenes, character presence, dialog, sentiment.
* Added basic ggplot2 themes.
* Added `stLogos` metadata dataset and related `st_logo()` function.
* Minor bug fixes and documentation updates.

# rtrek 0.2.2

* Minor updates related to dplyr/tibble.
* Documentation updates.

# rtrek 0.2.1

* Fixed errors in `stBooks` dataset where the number of words per book was calculated incorrectly.
* Documentation updates.

# rtrek 0.2.0

* Added an initial version of an API function `memory_alpha()` along with a collection of internal support functions for accessing Star Trek data from web portals available on the Memory Alpha website.
    * Internal portal functions that return data from portal and portal category web pages, and which may run recursively when necessary to compile complete content over multiple pages, are memoized. 
    * Functions like `ma_article()`, which return article content from a terminal endpoint are not memoized.
* Added `ma_search()` function for using the Memory Alpha site search via URL parameters.
* Added `ma_image()` function for downloading source images from Memory Alpha and loading into R as ggplot objects.
* Added an initial version of an API function `memory_beta()` and other `mb_*` Memory Beta analogs to Memory Alpha website functions.
* Added `mb_timeline()` for working with data from the Memory Beta Chronology.
* Added new datasets, mainly to timelines: `tlBooks`, `tlEvents`, `tlFootnotes`. Also added `stSeries` names and abbreviations table.
* Renamed `st_book_series()` and `stBooksWP` to `st_books_wiki()` and `stBooksWiki`, respectively.
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
* Minor refactor of `stapi()` internals and addition of `stapiEntities` dataset.
* Added optional (non-dependent) association with `trekfont` package with a function `st_font()` to list and preview fonts from that package.
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
* Added anti-DOS measures for API calls.
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
