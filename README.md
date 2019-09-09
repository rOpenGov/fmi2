# fmi2

[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis build status](https://travis-ci.org/rOpenGov/fmi2.svg?branch=master)](https://travis-ci.org/rOpenGov/fmi2)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/rOpenGov/fmi2?branch=master&svg=true)](https://ci.appveyor.com/project/rOpenGov/fmi2)
[![codecov](https://codecov.io/gh/rOpenGov/fmi2/branch/master/graph/badge.svg)](https://codecov.io/gh/rOpenGov/fmi2)

R client package for [the Finnish Meteorological Institute (FMI) open data API](https://en.ilmatieteenlaitos.fi/open-data-manual). `fmi2` provides access
to a subset of the FMI [download](http://en.ilmatieteenlaitos.fi/open-data-manual-accessing-data) 
service. Currently, the following FMI stored queries are avaible in `fmi2`:

| fmi2-function         | FMI API stored query                                 |
|-----------------------|------------------------------------------------------|
| `obs_weather_daily()` | fmi::observations::weather::daily::simple            |
| `obs_weather_hourly()`| fmi::observations::weather::hourly::simple           |

More data sets and queries may be wrapped in the future. If you have a 
particular need in mind, you're free to:

1. Fork the repository, modify the code and leave a pull request.
2. Leave an [issue](https://github.com/rOpenGov/fmi2/issues) with a description
on the improvements.

All data from the FMI is released under [the Creative Commons Attribution 4.0 
International license](https://creativecommons.org/licenses/by/4.0/). 

## Installation

`fmi2` is not yet on CRAN, but you can install it from GitHub with:

``` r
install.packages("remotes")
remotes::install_github("ropengov/fmi2")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
## basic example code
```

For a list of currently available data sets and queries, see XXX. 

## Contributors

+ Joona Lehtomäki <joona.lehtomaki@iki.fi>, package maintainer
+ Ilari Scheinin
