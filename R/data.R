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

#' Star Trek novel metadata from Wikipedia.
#'
#' A data frame with 719 rows and 6 columns containing metadata on Star Trek novels and other books taken from the primary Wikipedia page: \url{https://en.wikipedia.org/wiki/List_of_Star_Trek_novels}.
#' The data frame contains most of the novels but is not comprehensive, containing only the most easily scraped HTML table data, and may be out of date temporarily whenever new novels are published.
#'
#' There is considerable overlap in titles between \code{stBooksWiki} and \code{stBooks}, but also unique entries and they offer some different fields.
#'
#' @format A data frame
#' @seealso \code{\link{st_books_wiki}}, \code{\link{stBooks}}
"stBooksWiki"

#' Star Trek novel metadata.
#'
#' A data frame with 783 rows and 11 columns containing metadata on Star Trek novels and other books taken directly from original books.
#' The data frame contains most of the novels but is not comprehensive and may be out of date temporarily whenever new novels are published.
#' It is largely complete through the end of 2017, though some older entries are still missing.
#'
#' \code{stBooks} contains a number of additional columns providing metadata about each book that could only be parsed directly from books and not from the Wikipedia page that serves as the source for \code{stBooksWiki}.
#' These columns include the number of characters, words and chapters in a book. There may be some irregularities or erroneous entries based on the imperfect methods use to compile the metadata,
#' but it is overall an accurate dataset.
#'
#' The \code{nchap} column is largely accurate, but imperfect. Some entries suggest a book has hundreds of chapters, but the parser is not perfect at determining what constitutes a chapter.
#' However, many of the books with high numbers of chapters are not erroneous but rather indicate a reference book rather than a novel, or an omnibus or anthology.
#'
#' @format A data frame
#' @seealso \code{\link{stSeries}}, \code{\link{stBooksWiki}}
"stBooks"

#' Star Trek series.
#'
#' A data frame with 35 rows and 3 columns containing names and abbreviations of Star Trek series and anthologies.
#' There are so many because the table pertains to written works, which is inclusive of the more limited televised series.
#'
#' Some entries listed as series can be interpreted as miniseries, but that distinction is not made here.
#' The official line between the two is not always clear and can also change as more novels are released.
#'
#' Anthologies are listed as such, rather than as series. Reference manuals have a distinct entry.
#' The Miscellaneous category can be considered synonymous with All-Series/Crossover,
#' abbreviated elsewhere as simply \code{ST} for Star Trek in general, rather than as \code{MISC}.
#'
#' @format A data frame
#' @seealso \code{\link{st_books_wiki}}
"stSeries"

#' Star Trek API entities.
#'
#' A data frame with 40 rows and 4 columns listing the available STAPI entity IDs that can be passed to \code{\link{stapi}}, along with additional metadata regarding the content returned form an API call to each entity.
#' This data frame helps you see what you will obtain from API calls beforehand.
#' Every entity search returns a tibble data frame, with varying numbers of columns and different names depending on the entity content.
#' There is also one nested column containing the column names of the data frame returned for each entity. This can be inspected directly for specific entities or \code{stapiEntities} can be unnested with a function like \code{tidyr::unnest}.
#'
#' @format A data frame
#' @seealso \code{\link{stapi}}
"stapiEntities"

#' Star Trek novel-based timeline.
#'
#' A data frame with 2122 rows and 14 columns containing Star Trek timeline data. This dataset is novel-driven,
#' meaning that the timeline entries (rows) provide a chronologically ordered list of licensed Star Trek novels.
#'
#' Specifically, this curated dataset includes data derived from historical timeline information in the appendix of the Star Trek reference manual, Voyages of the Imagination,
#' which provides information on the large collection of licensed Star Trek literature.
#' The authors note that the original timeline includes "novels, short stories, eBooks, novelizations, Simon & Schuster Audio original audio books, Minstrel Books young adult books, and classic novels from Bantam and Ballantine Books, published through October 2006."
#'
#' While this data is very informative, it is clearly many years out of date. It is also necessarily speculative.
#' Settings are determined based in part on what is interpreted to be the intention of a given author for a given production.
#' Nevertheless, it still represents possibly the highest quality representation of the chronological ordering of Star Trek fiction that combines episodes and movies with written works.
#' The concurrent timeline of Star Trek TV episodes and movies are interleaved with the novels and other written fiction for fuller context resulting in a much richer timeline.
#' See the \code{tlEvents} dataset for an event-driven timeline.
#'
#' @format A data frame
#' @seealso \code{\link{tlEvents}} \code{\link{tlFootnotes}}
"tlBooks"

#' Star Trek event-based timeline.
#'
#' A data frame with 1241 rows and 6 columns containing Star Trek timeline data. This dataset is event-driven,
#' meaning that the timeline entries (rows) provide chronologically ordered historical events from the Star Trek universe.
#' See the \code{tlEvents} dataset for an event-driven timeline.
#'
#' This timeline was recreated from the timeline found at \url{http://www.maplenet.net/~trowbridge/timeline.htm}.
#' As with \code{tlBooks}, this timeline is quite out of date. In fact it is at least somewhat more out of date than \code{tlBooks}.
#' This timeline is also more problematic than the other, and less relevant moving forward. Its updating essentially ceased  as the other began.
#' See the URL for more details.
#'
#' However, it is included because unlike \code{tlBooks}, which is a timeline of production titles, this timeline dataset is event-driven.
#' While it may now be erroneous in places even independent from being out of date,
#' it is useful for its informative textual entries referencing historically significant events in Star Trek lore.
#'
#' @format A data frame
#' @seealso \code{\link{tlBooks}} \code{\link{tlFootnotes}}
"tlEvents"

#' Star Trek timeline footnotes.
#'
#' A data frame with 605 rows and 3 columns containing footnotes associated by ID with various entries in package timeline datasets, \code{tlBooks} and \code{tlEvents}.
#'
#' @format A data frame
#' @seealso \code{\link{tlBooks}} \code{\link{tlEvents}}
"tlFootnotes"

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
  dplyr::data_frame(
    dataset = c("stGeo", "stSpecies", "stTiles",
                "stBooks", "stBooksWiki", "stSeries",
                "stapiEntities",
                "tlBooks", "tlEvents", "tlFootnotes"),
    description = c("Map tile set locations of interest.",
                    "Basic intelligent species data.",
                    "Available map tile sets.",
                    "Star Trek novel metadata.",
                    "Star Trek novel metadata from Wikipedia.",
                    "Names and acronyms of Star Trek series",
                    "Star Trek API (STAPI) categories",
                    "Novel-based timeline dataset",
                    "Event-based timeline dataset",
                    "Timeline dataset footnotes"))
}
