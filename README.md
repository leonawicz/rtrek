
<!-- README.md is generated from README.Rmd. Please edit that file -->
rtrek <a hef="https://github.com/leonawicz/rtrek/blob/master/data-raw/images/rtrek.png?raw=true" _target="blank"><img src="https://github.com/leonawicz/rtrek/blob/master/data-raw/images/rtrek-small.png?raw=true" style="margin-left:10px;margin-bottom:5px;" width="120" align="right"></a>
==============================================================================================================================================================================================================================================================================================

<br/> **Author:** [Matthew Leonawicz](https://leonawicz.github.io/blog/)<br/> **License:** [MIT](https://opensource.org/licenses/MIT)<br/>

[![CRAN status](http://www.r-pkg.org/badges/version/rtrek)](https://cran.r-project.org/package=rtrek) [![CRAN downloads](http://cranlogs.r-pkg.org/badges/grand-total/rtrek)](https://cran.r-project.org/package=rtrek) [![Rdoc](http://www.rdocumentation.org/badges/version/rtrek)](http://www.rdocumentation.org/packages/rtrek) [![Travis-CI Build Status](https://travis-ci.org/leonawicz/rtrek.svg?branch=master)](https://travis-ci.org/leonawicz/rtrek) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/leonawicz/rtrek?branch=master&svg=true)](https://ci.appveyor.com/project/leonawicz/rtrek) [![Coverage Status](https://img.shields.io/codecov/c/github/leonawicz/rtrek/master.svg)](https://codecov.io/github/leonawicz/rtrek?branch=master) [![gitter](https://img.shields.io/badge/GITTER-join%20chat-green.svg)](https://gitter.im/leonawicz/rtrek)

The `rtrek` package provides datasets related to the Star Trek fictional universe and functions to assist with the data. It interfaces with [Wikipedia](https://www.wikipedia.org/), [STAPI](http://stapi.co/), [Memory Alpha](http://memory-alpha.wikia.com/wiki/Portal:Main) and [Memory Beta](http://memory-beta.wikia.com/wiki/Main_Page) to retrieve data, metadata and other information relating to Star Trek. It also contains local sample datasets covering a variety of topics such as Star Trek universe species data, geopolitical data, and summary datasets resulting from text mining analyses of Star Trek novels. The package also provides functions for working with data from other Star Trek-related R data packages containing larger datasets not stored in `rtrek`.

*Note: This package is in beta (and not just the quadrant). Breaking changes may occur.*

![](https://github.com/leonawicz/rtrek/blob/master/data-raw/images/rtrek_app1.png?raw=true)

*Image: Example [Leaflet map](https://leonawicz.github.io/rtrek/articles/sc.html) using non-geographic Star Trek map tiles.*

<br/> <br/>

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

Example
-------

<br/>

Use the Star Trek API (STAPI) to obtain information on the whereabouts and whenabouts of the infamous character, Q. Specifically, retrieve data on his appearances and the stardates when he shows up. The first API call does a lightweight, unobtrusive check to see how many pages of potential search results exist for characters in the database. There are a lot of characters. The second call grabs only page two results. The third call uses the universal/unique ID `uid` to retrieve data on Q. Think of these three successive uses of `stapi` as safe mode, search mode and extraction mode.

``` r
library(rtrek)
library(dplyr)
stapi("character", page_count = TRUE)
#> Total pages to retrieve all results: 64

stapi("character", page = 2)
#> # A tibble: 100 x 24
#>    uid      name   gender yearOfBirth monthOfBirth dayOfBirth placeOfBirth
#>    <chr>    <chr>  <chr>        <int> <lgl>        <lgl>      <chr>       
#>  1 CHMA000~ Stevi~ <NA>            NA NA           NA         <NA>        
#>  2 CHMA000~ Yeggie M               NA NA           NA         <NA>        
#>  3 CHMA000~ Arex   M               NA NA           NA         <NA>        
#>  4 CHMA000~ Joseph M               NA NA           NA         <NA>        
#>  5 CHMA000~ J. Zi~ <NA>            NA NA           NA         <NA>        
#>  6 CHMA000~ Doyle  M               NA NA           NA         <NA>        
#>  7 CHMA000~ Butler M               NA NA           NA         <NA>        
#>  8 CHMA000~ Lito   M               NA NA           NA         <NA>        
#>  9 CHMA000~ B. Mo~ <NA>            NA NA           NA         <NA>        
#> 10 CHMA000~ Anna ~ <NA>            NA NA           NA         <NA>        
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

Live long and prosper.

See the [introduction vignette](https://leonawicz.github.io/rtrek/articles/rtrek.html) for more details and examples.

Reference
---------

[Complete package reference and function documentation](https://leonawicz.github.io/rtrek/)
