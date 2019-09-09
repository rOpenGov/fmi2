
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fmi2 - R client for the Finnish Meteorological Institute’s (FMI) API

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis build
status](https://travis-ci.org/rOpenGov/fmi2.svg?branch=master)](https://travis-ci.org/rOpenGov/fmi2)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/rOpenGov/fmi2?branch=master&svg=true)](https://ci.appveyor.com/project/rOpenGov/fmi2)
[![codecov](https://codecov.io/gh/rOpenGov/fmi2/branch/master/graph/badge.svg)](https://codecov.io/gh/rOpenGov/fmi2)
<!-- badges: end -->

R client package for [the Finnish Meteorological Institute (FMI) open
data API](https://en.ilmatieteenlaitos.fi/open-data-manual). `fmi2`
provides access to a subset of the FMI
[download](http://en.ilmatieteenlaitos.fi/open-data-manual-accessing-data)
service. FMI maintains and is reponsible for the data available through
their API, but has not official connections to `fmi2`.

All data from the FMI is released under [the Creative Commons
Attribution 4.0 International
license](https://creativecommons.org/licenses/by/4.0/).

## Installation

`fmi2` is not yet on CRAN, but you can install the development version
from [GitHub](https://github.com/rOpenGov/fmi2) with:

``` r
# install.packages("remotes")
remotes::install_github("rOpenGov/fmi2")
```

## Details

Currently, the following FMI stored queries are avaible in
`fmi2`:

| fmi2-function                                                                               | FMI API stored query                       |
| ------------------------------------------------------------------------------------------- | ------------------------------------------ |
| [`obs_weather_daily()`](https://ropengov.github.io/fmi2/reference/obs_weather_daily.html)   | fmi::observations::weather::daily::simple  |
| [`obs_weather_hourly()`](https://ropengov.github.io/fmi2/reference/obs_weather_hourly.html) | fmi::observations::weather::hourly::simple |

More data sets and queries may be wrapped in the future.

## Example

For usage examples, see the package [function
reference](https://ropengov.github.io/fmi2/reference/index.html) and the
following vignettes:

  - [Getting weather observation
    data](https://ropengov.github.io/fmi2/articles/weather_observation_data.html)

## Contributing

If you have a particular need in mind, you’re free to:

1.  Fork the repository, modify the code and leave a pull request.
2.  Leave an [issue](https://github.com/rOpenGov/fmi2/issues) with a
    description on the improvements.

## Why fmi2?

If this is `fmi2`, where’s the first `fmi`\!? Good question, `fmi` can
be found [here](https://github.com/rOpenGov/fmi) and is no longer
developed or maintained. `fmi` was developed back in the day when
accessing data from a WFS in R was much more difficult. Hence, the
package is much more complicated than `fmi2` and too laborious to
maintain.
