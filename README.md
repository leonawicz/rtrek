
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtrek <img src="man/figures/logo.png" style="margin-left:10px;margin-bottom:5px;" width="120" align="right">

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/)
[![CRAN
status](http://www.r-pkg.org/badges/version/rtrek)](https://cran.r-project.org/package=rtrek)
[![CRAN
downloads](http://cranlogs.r-pkg.org/badges/grand-total/rtrek)](https://cran.r-project.org/package=rtrek)
[![Github
Stars](https://img.shields.io/github/stars/leonawicz/rtrek.svg?style=social&label=Github)](https://github.com/leonawicz/rtrek)

The `rtrek` package provides datasets related to the Star Trek fictional
universe and functions for working with those datasets. It interfaces
with the [Star Trek API](http://stapi.co/) (STAPI), [Memory
Alpha](https://memory-alpha.fandom.com/wiki/Portal:Main) and [Memory
Beta](https://memory-beta.fandom.com/wiki/Main_Page) to retrieve data,
metadata and other information relating to Star Trek.

The package also contains several local datasets covering a variety of
topics such as Star Trek timeline data, universe species data and
geopolitical data. Some of these are more information rich, while others
are toy examples useful for simple demonstrations. The bulk of Star Trek
data is accessed from external sources by API. A future version of
`rtrek` will also include summary datasets resulting from text mining
analyses of Star Trek novels.

<p style="text-align:center;">
<img src="https://github.com/leonawicz/rtrek/blob/master/data-raw/images/rtrek_app1.png?raw=true" width="100%">
</p>

*Image: Example [Leaflet
map](https://leonawicz.github.io/rtrek/articles/sc.html) using
non-geographic Star Trek map tiles.*

<br/>

## Installation

Install the CRAN release of `rtrek` with

``` r
install.packages("rtrek")
```

Install the development version from GitHub with

``` r
# install.packages("remotes")
remotes::install_github("leonawicz/rtrek")
```

<h2 style="padding-bottom:0px;">
Examples
</h2>

<img src="https://github.com/leonawicz/rtrek/blob/master/data-raw/images/dixon_hill.jpg?raw=true" width=320 style="float: right; padding-left: 20px; padding-bottom:5px;">

<h4 style="padding-top:50px;padding-bottom:0px;">
Time to be good detectives. Good thing Data has R installed.
</h4>

These are just a few examples to help you jump right in. See the package
articles for more.

### STAPI

Use the Star Trek API (STAPI) to obtain information on the infamous
character, Q. Specifically, retrieve data on his appearances and the
stardates when he shows up.

The first API call does a lightweight, unobtrusive check to see how many
pages of potential search results exist for characters in the database.
There are a lot of characters.

The second call grabs only page two results. The third call uses the
universal/unique ID `uid` to retrieve data on Q. Think of these three
successive uses of `stapi` as safe mode, search mode and extraction
mode.

``` r
library(rtrek)
library(dplyr)
stapi("character", page_count = TRUE)
#> Total pages to retrieve all results: 76

stapi("character", page = 1) |> select(uid, name)
#> # A tibble: 100 × 2
#>    uid            name         
#>    <chr>          <chr>        
#>  1 CHMA0000215045 0413 Theta   
#>  2 CHMA0000174718 0718         
#>  3 CHMA0000283851 10111        
#>  4 CHMA0000278055 335          
#>  5 CHMA0000282741 355          
#>  6 CHMA0000026532 A'trom       
#>  7 CHMA0000280385 A. Armaganian
#>  8 CHMA0000226457 A. Baiers    
#>  9 CHMA0000232390 A. Baiers    
#> 10 CHMA0000068580 A. Banda     
#> # ℹ 90 more rows

Q <- "CHMA0000025118" #unique ID
Q <- stapi("character", uid = Q)
Q$episodes |> select(uid, title, stardateFrom, stardateTo)
#>               uid                 title stardateFrom stardateTo
#> 1  EPMA0000259941               Veritas           NA         NA
#> 2  EPMA0000000651              Tapestry           NA         NA
#> 3  EPMA0000000500            Hide And Q      41590.5    41590.5
#> 4  EPMA0000277408        The Star Gazer           NA         NA
#> 5  EPMA0000280052              Farewell           NA         NA
#> 6  EPMA0000279099            Two of One           NA         NA
#> 7  EPMA0000278606               Watcher           NA         NA
#> 8  EPMA0000001510    The Q and the Grey      50384.2    50392.7
#> 9  EPMA0000001413                True Q      46192.3    46192.3
#> 10 EPMA0000000845                Q-Less      46531.2    46531.2
#> 11 EPMA0000001329                 Q Who      42761.3    42761.3
#> 12 EPMA0000278900    Fly Me to the Moon           NA         NA
#> 13 EPMA0000000483 Encounter at Farpoint      41153.7    41153.7
#> 14 EPMA0000001458    All Good Things...      47988.0    47988.0
#> 15 EPMA0000162588            Death Wish      49301.2    49301.2
#> 16 EPMA0000289337   The Last Generation           NA         NA
#> 17 EPMA0000001347                Deja Q      43539.1    43539.1
#> 18 EPMA0000277535               Penance           NA         NA
#> 19 EPMA0000278226          Assimilation           NA         NA
#> 20 EPMA0000279450                 Mercy           NA         NA
#> 21 EPMA0000001619                    Q2      54704.5    54704.5
#> 22 EPMA0000001377                  Qpid      44741.9    44741.9
```

### Memory Alpha

Obtain content and metadata from the article about Spock on Memory
Alpha:

``` r
x <- ma_article("Spock")
x
#> # A tibble: 1 × 4
#>   title content    metadata          categories       
#>   <chr> <list>     <list>            <list>           
#> 1 Spock <xml_ndst> <tibble [1 × 18]> <tibble [15 × 2]>
x$metadata[[1]]$Born
#> [1] "January 6, 2230 (stardate 2230.06)|ShiKahr, Vulcan"
```

### Memory Beta

Spock was born in 2230. Obtain a subset of the Star Trek universe
historical timeline for that year:

``` r
mb_timeline(2230)
#> 2230
#> $events
#> # A tibble: 8 × 2
#>   period details                                                      
#>   <chr>  <chr>                                                        
#> 1 2230   Events                                                       
#> 2 2230   Argelius II  and Betelgeuse become members of the Federation.
#> 3 2230   Births and Deaths                                            
#> 4 2230   Spock is born deep within a cave in Vulcan's Forge on Vulcan.
#> 5 2230   T'Pring is born on Vulcan.                                   
#> 6 2230   George Samuel Kirk, Jr. is born.                             
#> 7 2230   David Rabin is born.                                         
#> 8 2230   Roy John Moss is born.                                       
#> 
#> $stories
#> # A tibble: 5 × 11
#>   title   title_url colleciton collection_url section context series date  media
#>   <chr>   <chr>     <chr>      <chr>          <chr>   <chr>   <chr>  <chr> <chr>
#> 1 Burnin… Burning_… <NA>       <NA>           Chapte… <NA>    The O… 2230  novel
#> 2 Star T… Star_Tre… <NA>       <NA>           Chapte… <NA>    The O… 2230  movi…
#> 3 IDW St… IDW_Star… Star Trek… Star_Trek_(ID… 2230 f… <NA>    The O… 2230  comic
#> 4 Star T… Star_Tre… <NA>       <NA>           Chapte… <NA>    The O… 2230  movi…
#> 5 Sarek   Sarek_(n… <NA>       <NA>           Chapte… <NA>    The O… 12 N… novel
#> # ℹ 2 more variables: notes <chr>, image_url <chr>
```

Live long and prosper.

## Packages in the trekverse

<div class="row">

<div class="col-sm-2">

<a href="https://github.com/leonawicz/rtrek"><img src="https://raw.githubusercontent.com/leonawicz/rtrek/master/man/figures/logo.png" style="margin-right:20px;margin-bottom:0;" width="120" align="left"></a>

</div>

<div class="col-sm-10">

<h4 style="padding:30px 0 0 0;margin-top:5px;margin-bottom:5px;">
<a href="https://github.com/leonawicz/rtrek">rtrek</a>: The core Star
Trek package
</h4>

Datasets related to Star Trek, API wrappers to external data sources,
and more.

</div>

</div>

<br/>

<div class="row">

<div class="col-sm-2">

<a href="https://github.com/leonawicz/lcars"><img src="https://raw.githubusercontent.com/leonawicz/lcars/master/man/figures/logo.png" style="margin-right:20px;margin-bottom:0;" width="120" align="left"></a>

</div>

<div class="col-sm-10">

<h4 style="padding:30px 0 0 0;margin-top:5px;margin-bottom:5px;">
<a href="https://github.com/leonawicz/lcars">lcars</a>: LCARS aesthetic
for Shiny
</h4>

Create Shiny apps based on the Library Computer Access/Retrieval System
(LCARS).

</div>

</div>

<br/>

<div class="row">

<div class="col-sm-2">

<a href="https://github.com/leonawicz/trekcolors"><img src="https://raw.githubusercontent.com/leonawicz/trekcolors/master/man/figures/logo.png" style="margin-right:20px;margin-bottom:0;" width="120" align="left"></a>

</div>

<div class="col-sm-10">

<h4 style="padding:30px 0 0 0;margin-top:5px;margin-bottom:5px;">
<a href="https://github.com/leonawicz/trekcolors">trekcolors</a>: A
color palette package
</h4>

Predefined and customizable Star Trek themed color palettes and related
functions.

</div>

</div>

<br/>

<div class="row">

<div class="col-sm-2">

<a href="https://github.com/leonawicz/trekfont"><img src="https://raw.githubusercontent.com/leonawicz/trekfont/master/man/figures/logo.png" style="margin-right:20px;margin-bottom:0;" width="120" align="left"></a>

</div>

<div class="col-sm-10">

<h4 style="padding:30px 0 0 0;margin-top:5px;margin-bottom:5px;">
<a href="https://github.com/leonawicz/trekfont">trekfont</a>: A fonts
package
</h4>

True (Trek) type fonts to style your Star Trek themed graphics text.

</div>

</div>

<br>

## Citation

Matthew Leonawicz (2023). rtrek: Data analysis relating to Star Trek. R
package version 0.4.0. <https://CRAN.R-project.org/package=rtrek>

## Contribute

Contributions are welcome. Contribute through GitHub via pull request.
Please create an issue first if it is regarding any substantive feature
add or change.

------------------------------------------------------------------------

Please note that the `rtrek` project is released with a [Contributor
Code of
Conduct](https://github.com/leonawicz/rtrek/blob/master/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
