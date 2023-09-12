#' Raster grid location data for stellar cartographic map tile sets.
#'
#' A data frame of with 18 rows and 4 columns. This data frame has an ID column for map tile set, a column of location names, and columns of respective column and row number of each location per map tile set.
#'
#' @format A data frame
"stGeo"

#' Species names and avatars, linked primarily from Memory Alpha.
#'
#' A data frame with 9 rows and 2 columns.
#'
#' @format A data frame
"stSpecies"

#' Available Star Trek map tile sets.
#'
#' A data frame with 2 row and 8 columns.
#'
#' @format A data frame
"stTiles"

#' Star Trek novel metadata.
#'
#' A data frame with 783 rows and 11 columns containing metadata on Star Trek
#' novels and other books taken directly from original books. The data frame
#' contains most of the novels but is not comprehensive and may be out of date
#' temporarily whenever new novels are published. It is largely complete through
#' the end of 2017, though some older entries are still missing.
#'
#' `stBooks`: There may be some irregularities or erroneous entries based on the
#' imperfect methods use to compile the metadata, but it is overall an accurate
#' dataset.
#'
#' The `nchap` column is largely accurate, but imperfect. Some entries suggest a
#' book has an unusual number of chapters, but the parser is not perfect at
#' determining what constitutes a chapter. However, many of the books with
#' unusually high numbers of chapters are not erroneous but rather indicate a
#' reference book, omnibus or anthology, as opposed to a standard novel.
#'
#' @format A data frame
#' @seealso [stSeries()], [st_books_wiki()]
"stBooks"

#' Star Trek series.
#'
#' A data frame with 35 rows and 3 columns containing names and abbreviations of
#' Star Trek series and anthologies. There are so many because the table
#' pertains to written works, which is inclusive of the more limited televised
#' series.
#'
#' Some entries listed as series can be interpreted as miniseries, but that
#' distinction is not made here. The official line between the two is not always
#' clear and can also change as more novels are released.
#'
#' Anthologies are listed as such, rather than as series. Reference manuals have
#' a distinct entry. The Miscellaneous category can be considered synonymous
#' with All-Series/Crossover, abbreviated elsewhere as simply `ST` for Star Trek
#' in general, rather than as `MISC`.
#'
#' @format A data frame
#' @seealso [st_books_wiki()]
"stSeries"

#' Star Trek API entities.
#'
#' A data frame with 40 rows and 4 columns listing the available STAPI entity
#' IDs that can be passed to [stapi()], along with additional metadata regarding
#' the content returned form an API call to each entity. This data frame helps
#' you see what you will obtain from API calls beforehand. Every entity search
#' returns a tibble data frame, with varying numbers of columns and different
#' names depending on the entity content. There is also one nested column
#' containing the column names of the data frame returned for each entity. This
#' can be inspected directly for specific entities or `stapiEntities` can be
#' unnested with a function like `tidyr::unnest()`.
#'
#' @format A data frame
#' @seealso [stapi()]
"stapiEntities"

#' Star Trek novel-based timeline.
#'
#' A data frame with 2122 rows and 14 columns containing Star Trek timeline
#' data. This dataset is novel-driven, meaning that the timeline entries (rows)
#' provide a chronologically ordered list of licensed Star Trek novels.
#'
#' Specifically, this curated dataset includes data derived from historical
#' timeline information in the appendix of the Star Trek reference manual,
#' Voyages of the Imagination, which provides information on the large
#' collection of licensed Star Trek literature. The authors note that the
#' original timeline includes "novels, short stories, eBooks, novelizations,
#' Simon & Schuster Audio original audio books, Minstrel Books young adult
#' books, and classic novels from Bantam and Ballantine Books, published through
#' October 2006."
#'
#' While this data is very informative, it is clearly many years out of date. It
#' is also necessarily speculative. Settings are determined based in part on
#' what is interpreted to be the intention of a given author for a given
#' production. Nevertheless, it still represents possibly the highest quality
#' representation of the chronological ordering of Star Trek fiction that
#' combines episodes and movies with written works. The concurrent timeline of
#' Star Trek TV episodes and movies are interleaved with the novels and other
#' written fiction for fuller context resulting in a much richer timeline.
#' See the `tlEvents` dataset for an event-driven timeline.
#'
#' @format A data frame
#' @seealso [tlEvents()] [tlFootnotes()]
"tlBooks"

#' Star Trek event-based timeline.
#'
#' A data frame with 1241 rows and 6 columns containing Star Trek timeline data.
#' This dataset is event-driven, meaning that the timeline entries (rows)
#' provide chronologically ordered historical events from the Star Trek
#' universe. See the `tlBooks` dataset for an novel-driven timeline.
#'
#' As with `tlBooks`, this timeline is quite out of date. In fact it is at least
#' somewhat more out of date than `tlBooks`. This timeline is also more
#' problematic than the other, and less relevant moving forward. Its updating
#' essentially ceased as the other began.
#'
#' However, it is included because unlike `tlBooks`, which is a timeline of
#' production titles, this timeline dataset is event-driven. While it may now be
#' erroneous in places even independent from being out of date, it is useful for
#' its informative textual entries referencing historically significant events
#' in Star Trek lore.
#'
#' @format A data frame
#' @seealso [tlBooks()] [tlFootnotes()]
"tlEvents"

#' Star Trek timeline footnotes.
#'
#' A data frame with 605 rows and 3 columns containing footnotes associated by
#' ID with various entries in package timeline datasets, `tlBooks` and
#' `tlEvents`.
#'
#' @format A data frame
#' @seealso [tlBooks()] [tlEvents()]
"tlFootnotes"

#' Star Trek logos metadata.
#'
#' A data frame with 236 rows and 3 columns containing Star Trek logo metadata:
#' category, description and URL. Logo artwork credited to Kris Trigwell. The
#' logo images are served by st-minutiae.com for personal and fair use.
#'
#' @format A data frame
#' @seealso [st_logo()]
"stLogos"

#' Available datasets
#'
#' List the available datasets in the rtrek package.
#'
#' @return a character vector.
#' @export
#'
#' @examples
#' st_datasets()
st_datasets <- function(){
  dplyr::tibble(
    dataset = c("stGeo", "stSpecies", "stTiles", "stBooks", "stSeries",
                "stapiEntities", "stLogos", "tlBooks", "tlEvents",
                "tlFootnotes"),
    description = c("Map tile set locations of interest.",
                    "Basic intelligent species data.",
                    "Available map tile sets.",
                    "Star Trek novel metadata.",
                    "Names and acronyms of Star Trek series",
                    "Star Trek API (STAPI) categories",
                    "Metadata for various Star Trek logos",
                    "Novel-based timeline dataset",
                    "Event-based timeline dataset",
                    "Timeline dataset footnotes"))
}
