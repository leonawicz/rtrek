
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtrek <img src="man/figures/logo.png" style="margin-left:10px;margin-bottom:5px;" width="120" align="right">

**Author:** [Matthew Leonawicz](https://leonawicz.github.io/blog/)
<a href="https://orcid.org/0000-0001-9452-2771" target="orcid.widget">
<image class="orcid" src="https://members.orcid.org/sites/default/files/vector_iD_icon.svg" height="16"></a>
[![gitter](https://img.shields.io/badge/GITTER-join%20chat-green.svg)](https://gitter.im/leonawicz/rtrek)
<br/> **License:** [MIT](https://opensource.org/licenses/MIT)<br/>

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Travis-CI Build
Status](https://travis-ci.org/leonawicz/rtrek.svg?branch=master)](https://travis-ci.org/leonawicz/rtrek)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/leonawicz/rtrek?branch=master&svg=true)](https://ci.appveyor.com/project/leonawicz/rtrek)
[![Coverage
Status](https://img.shields.io/codecov/c/github/leonawicz/rtrek/master.svg)](https://codecov.io/github/leonawicz/rtrek?branch=master)

[![CRAN
status](http://www.r-pkg.org/badges/version/rtrek)](https://cran.r-project.org/package=rtrek)
[![CRAN
downloads](http://cranlogs.r-pkg.org/badges/grand-total/rtrek)](https://cran.r-project.org/package=rtrek)
[![Github
Stars](https://img.shields.io/github/stars/leonawicz/rtrek.svg?style=social&label=Github)](https://github.com/leonawicz/rtrek)

The `rtrek` package provides datasets related to the Star Trek fictional
universe and functions for working with those datasets. It interfaces
with the [Star Trek API](http://stapi.co/) (STAPI), [Memory
Alpha](http://memory-alpha.wikia.com/) and [Memory
Beta](http://memory-beta.wikia.com/) to retrieve data, metadata and
other information relating to Star Trek.

<hr>

*If you enjoy my R community contributions, consider* ***[buying me a
coffee in Ko-fi](https://ko-fi.com/leonawicz)*** *(or through PayPal
<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=DHMC76S85GJCY&source=url"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" /></a>)
so I can keep developing and maintaining this and other packages :)*

<hr>

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

## Installation<img src="https://github.com/leonawicz/rtrek/blob/master/data-raw/images/dixon_hill.jpg?raw=true" width=320 style="float: right; padding-left: 10px; padding-bottom:5px;">

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

<h4 style="padding-top:50px;padding-bottom:0px;">

Time to be good detectives. Good thing Data has R installed.

</h4>

These are just a few examples to help you jump right in. See the package
articles for more.

### STAPI

Use the Star Trek API (STAPI) to obtain information on the infamous
character, Q. Specifically, retrieve data on his appearances and the
stardates when he shows up. The first API call does a lightweight,
unobtrusive check to see how many pages of potential search results
exist for characters in the database. There are a lot of characters. The
second call grabs only page two results. The third call uses the
universal/unique ID `uid` to retrieve data on Q. Think of these three
successive uses of `stapi` as safe mode, search mode and extraction
mode.

``` r
library(rtrek)
library(dplyr)
stapi("character", page_count = TRUE)
#> Total pages to retrieve all results: 66

stapi("character", page = 1) %>% select(uid, name)
#> # A tibble: 100 x 2
#>    uid            name            
#>    <chr>          <chr>           
#>  1 CHMA0000021696 Pechetti        
#>  2 CHMA0000028502 Pomet           
#>  3 CHMA0000134966 Eddie Newsom    
#>  4 CHMA0000101321 T. Virts        
#>  5 CHMA0000053158 Annabelle series
#>  6 CHMA0000008975 Torias Dax      
#>  7 CHMA0000232471 T. Peel         
#>  8 CHMA0000087568 Grathon Tolar   
#>  9 CHMA0000190805 C. Russell      
#> 10 CHMA0000069617 Mike Vejar      
#> # ... with 90 more rows

Q <- "CHMA0000025118" #unique ID
Q <- stapi("character", uid = Q)
Q$episodes %>% select(uid, title, stardateFrom, stardateTo)
#>              uid                 title stardateFrom stardateTo
#> 1 EPMA0000001458    All Good Things...      47988.0    47988.0
#> 2 EPMA0000000845                Q-Less      46531.2    46531.2
#> 3 EPMA0000001329                 Q Who      42761.3    42761.3
#> 4 EPMA0000000651              Tapestry           NA         NA
#> 5 EPMA0000001510    The Q and the Grey      50384.2    50392.7
#> 6 EPMA0000000483 Encounter at Farpoint      41153.7    41153.7
#> 7 EPMA0000162588            Death Wish           NA         NA
#> 8 EPMA0000001413                True Q      46192.3    46192.3
#> 9 EPMA0000001377                  Qpid      44741.9    44741.9
```

### Memory Alpha

Obtain content and metadata from the article about Spock on Memory
Alpha:

``` r
x <- ma_article("Spock")
x
#> # A tibble: 1 x 4
#>   title content    metadata          categories       
#>   <chr> <list>     <list>            <list>           
#> 1 Spock <xml_ndst> <tibble [1 x 18]> <tibble [14 x 2]>
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
#> # A tibble: 5 x 4
#>   period id            date  notes                                         
#>   <chr>  <chr>         <chr> <chr>                                         
#> 1 2230   Events        <NA>  Argelius II  and Betelgeuse become members of~
#> 2 2230   Births_and_D~ <NA>  Spock is born deep within a cave in Vulcan's ~
#> 3 2230   Births_and_D~ <NA>  George Samuel Kirk, Jr. is born.[5]           
#> 4 2230   Births_and_D~ <NA>  David Rabin is born.[6]                       
#> 5 2230   Births_and_D~ <NA>  Roy John Moss is born.[7]                     
#> 
#> $stories
#> # A tibble: 5 x 11
#>   title title_url colleciton collection_url section context series date 
#>   <chr> <chr>     <chr>      <chr>          <chr>   <chr>   <chr>  <chr>
#> 1 Burn~ Burning_~ <NA>       <NA>           Chapte~ <NA>    The O~ 2230 
#> 2 Star~ Star_Tre~ <NA>       <NA>           Chapte~ <NA>    The O~ 2230 
#> 3 IDW ~ IDW_Star~ Star Trek~ Star_Trek_(ID~ 2230 f~ <NA>    The O~ 2230 
#> 4 Star~ Star_Tre~ <NA>       <NA>           Chapte~ <NA>    The O~ 2230 
#> 5 Sarek Sarek_(n~ <NA>       <NA>           Chapte~ <NA>    The O~ 12 N~
#> # ... with 3 more variables: media <chr>, notes <chr>, image_url <chr>
```

Live long and prosper.

## Packges in the trekverse

<div class="row">

<div class="col-sm-2">

<a href="https://github.com/leonawicz/rtrek"><img src="https://raw.githubusercontent.com/leonawicz/rtrek/master/man/figures/logo.png" style="margin-right:20px;margin-bottom:0;" width="60" align="left"></a>

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

<a href="https://github.com/leonawicz/trekcolors"><img src="https://raw.githubusercontent.com/leonawicz/trekcolors/master/man/figures/logo.png" style="margin-right:20px;margin-bottom:0;" width="60" align="left"></a>

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

<a href="https://github.com/leonawicz/trekfont"><img src="https://raw.githubusercontent.com/leonawicz/trekfont/master/man/figures/logo.png" style="margin-right:20px;margin-bottom:0;" width="60" align="left"></a>

</div>

<div class="col-sm-10">

<h4 style="padding:30px 0 0 0;margin-top:5px;margin-bottom:5px;">

<a href="https://github.com/leonawicz/trekfont">trekfont</a>: A fonts
package

</h4>

True (Trek) type fonts to style your Star Trek themed graphics text.

</div>

</div>

-----

Please note that the `rtrek` project is released with a [Contributor
Code of
Conduct](https://leonawicz.github.io/rtrek/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
