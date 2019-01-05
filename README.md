
<!-- README.md is generated from README.Rmd. Please edit that file -->
rtrek <img src="man/figures/logo.png" style="margin-left:10px;margin-bottom:5px;" width="120" align="right">
============================================================================================================

**Author:** [Matthew Leonawicz](https://leonawicz.github.io/blog/) <a href="https://orcid.org/0000-0001-9452-2771" target="orcid.widget"> <image class="orcid" src="https://members.orcid.org/sites/default/files/vector_iD_icon.svg" height="16"></a> [![gitter](https://img.shields.io/badge/GITTER-join%20chat-green.svg)](https://gitter.im/leonawicz/rtrek) <br/> **License:** [MIT](https://opensource.org/licenses/MIT)<br/>

[![CRAN status](http://www.r-pkg.org/badges/version/rtrek)](https://cran.r-project.org/package=rtrek) [![CRAN downloads](http://cranlogs.r-pkg.org/badges/grand-total/rtrek)](https://cran.r-project.org/package=rtrek) [![Rdoc](http://www.rdocumentation.org/badges/version/rtrek)](http://www.rdocumentation.org/packages/rtrek) [![Travis-CI Build Status](https://travis-ci.org/leonawicz/rtrek.svg?branch=master)](https://travis-ci.org/leonawicz/rtrek) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/leonawicz/rtrek?branch=master&svg=true)](https://ci.appveyor.com/project/leonawicz/rtrek) [![Coverage Status](https://img.shields.io/codecov/c/github/leonawicz/rtrek/master.svg)](https://codecov.io/github/leonawicz/rtrek?branch=master)

The `rtrek` package provides datasets related to the Star Trek fictional universe and functions to assist with the data. It interfaces with [Wikipedia](https://www.wikipedia.org/), [STAPI](http://stapi.co/), [Memory Alpha](http://memory-alpha.wikia.com/wiki/Portal:Main) and [Memory Beta](http://memory-beta.wikia.com/wiki/Main_Page) to retrieve data, metadata and other information relating to Star Trek. It also contains local sample datasets covering a variety of topics such as Star Trek universe species data, geopolitical data, and summary datasets resulting from text mining analyses of Star Trek novels. The package also provides functions for working with data from other Star Trek-related R data packages containing larger datasets not stored in `rtrek`.

*Note: This package is in beta (and not just the quadrant). Breaking changes may occur.*

![](https://github.com/leonawicz/rtrek/blob/master/data-raw/images/rtrek_app1.png?raw=true)

*Image: Example [Leaflet map](https://leonawicz.github.io/rtrek/articles/sc.html) using non-geographic Star Trek map tiles.*

<br/>

Installation
------------

Install `rtrek` from CRAN with:

``` r
install.packages("rtrek")
```

Install the development version of `rtrek` from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("leonawicz/rtrek")
```

Examples
--------

These are just a few examples to help you jump right in. See the package articles for more.

### STAPI

Use the Star Trek API (STAPI) to obtain information on the infamous character, Q. Specifically, retrieve data on his appearances and the stardates when he shows up. The first API call does a lightweight, unobtrusive check to see how many pages of potential search results exist for characters in the database. There are a lot of characters. The second call grabs only page two results. The third call uses the universal/unique ID `uid` to retrieve data on Q. Think of these three successive uses of `stapi` as safe mode, search mode and extraction mode.

``` r
library(rtrek)
library(dplyr)
stapi("character", page_count = TRUE)
#> Total pages to retrieve all results: 64

stapi("character", page = 2)
#> # A tibble: 100 x 24
#>    uid   name  gender yearOfBirth monthOfBirth dayOfBirth placeOfBirth
#>    <chr> <chr> <chr>        <int> <lgl>        <lgl>      <chr>       
#>  1 CHMA~ Stev~ <NA>            NA NA           NA         <NA>        
#>  2 CHMA~ Yegg~ M               NA NA           NA         <NA>        
#>  3 CHMA~ Arex  M               NA NA           NA         <NA>        
#>  4 CHMA~ Jose~ M               NA NA           NA         <NA>        
#>  5 CHMA~ J. Z~ <NA>            NA NA           NA         <NA>        
#>  6 CHMA~ Doyle M               NA NA           NA         <NA>        
#>  7 CHMA~ Butl~ M               NA NA           NA         <NA>        
#>  8 CHMA~ Lito  M               NA NA           NA         <NA>        
#>  9 CHMA~ B. M~ <NA>            NA NA           NA         <NA>        
#> 10 CHMA~ Anna~ <NA>            NA NA           NA         <NA>        
#> # ... with 90 more rows, and 17 more variables: yearOfDeath <int>,
#> #   monthOfDeath <lgl>, dayOfDeath <lgl>, placeOfDeath <lgl>,
#> #   height <int>, weight <int>, deceased <lgl>, bloodType <lgl>,
#> #   maritalStatus <chr>, serialNumber <chr>, hologramActivationDate <lgl>,
#> #   hologramStatus <lgl>, hologramDateStatus <lgl>, hologram <lgl>,
#> #   fictionalCharacter <lgl>, mirror <lgl>, alternateReality <lgl>

Q <- "CHMA0000025118"  #unique ID
Q <- stapi("character", uid = Q)
Q$episodes %>% select(uid, title, stardateFrom, stardateTo)
#>              uid                 title stardateFrom stardateTo
#> 1 EPMA0000001458    All Good Things...      47988.0    47988.0
#> 2 EPMA0000001329                 Q Who      42761.3    42761.3
#> 3 EPMA0000001377                  Qpid      44741.9    44741.9
#> 4 EPMA0000000483 Encounter at Farpoint      41153.7    41153.7
#> 5 EPMA0000000651              Tapestry           NA         NA
#> 6 EPMA0000000845                Q-Less      46531.2    46531.2
#> 7 EPMA0000162588            Death Wish           NA         NA
#> 8 EPMA0000001413                True Q      46192.3    46192.3
#> 9 EPMA0000001510    The Q and the Grey      50384.2    50392.7
```

### Memory Alpha

Obtain content and metadata from the article about Spock on Memory Alpha:

``` r
x <- ma_article("Spock")
x
#> # A tibble: 1 x 4
#>   title content           metadata          categories       
#>   <chr> <list>            <list>            <list>           
#> 1 Spock <S3: xml_nodeset> <tibble [1 x 17]> <tibble [14 x 2]>
x$metadata[[1]]$Born
#> [1] "January 6, 2230 (stardate 2230.06)|ShiKahr, Vulcan"
```

### Memory Beta

Spock was born in 2230. Obtain a subset of the Star Trek universe historical timeline for that year:

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

See the [introduction vignette](https://leonawicz.github.io/rtrek/articles/rtrek.html) for more details and examples.

Reference
---------

[Complete package reference and function documentation](https://leonawicz.github.io/rtrek/)

------------------------------------------------------------------------

Please note that the `rtrek` project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
