
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fmi2 - R client for the Finnish Meteorological Institute’s (FMI) API <a href='https://ropengov.github.io/fmi2/'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![rOG-badge](https://ropengov.github.io/rogtemplate/reference/figures/ropengov-badge.svg)](https://ropengov.org/)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![codecov](https://codecov.io/gh/rOpenGov/fmi2/branch/master/graph/badge.svg)](https://app.codecov.io/gh/rOpenGov/fmi2)
[![CRAN
status](https://www.r-pkg.org/badges/version/fmi2)](https://CRAN.R-project.org/package=fmi2)
[![R build
status](https://github.com/rOpenGov/fmi2/workflows/R-CMD-check/badge.svg)](https://github.com/rOpenGov/fmi2/actions)

<!-- badges: end -->

R client package for [the Finnish Meteorological Institute (FMI) open
data API](https://en.ilmatieteenlaitos.fi/open-data-manual). `fmi2`
provides access to a subset of the FMI
[download](https://en.ilmatieteenlaitos.fi/open-data-manual-accessing-data)
service. FMI maintains and is reponsible for the data available through
their API, but has no official connections to `fmi2`.

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

Currently, the following FMI stored queries are available in `fmi2`:

| Stored query                                    | Description                       | No. parameters | fmi2 function name  |
|:------------------------------------------------|:----------------------------------|---------------:|:--------------------|
| fmi::ef::stations                               | Environmental Monitoring Stations |              4 | fmi_stations        |
| fmi::observations::weather::daily::simple       | Daily Weather Observations        |             11 | obs_weather_daily   |
| fmi::observations::weather::hourly::simple      | Hourly Weather Observations       |             12 | obs_weather_hourly  |
| fmi::observations::weather::monthly::simple     | Monthly Weather Observations      |             11 | obs_weather_monthly |
| urban::observations::airquality::hourly::simple | Hourly Air Quality Observations   |             11 | get_airquality      |

There are also wrapper functions that call the functions above. These
functions are:

| Function name     | Description                        |
|:------------------|:-----------------------------------|
| get_precipitation | Returns precipitation observations |
| get_temperature   | Returns temperature observations   |
| get_wind          | Returns wind observations          |

More data sets and queries may be wrapped in the future.

## Example

For usage examples, see the package [function
reference](https://ropengov.github.io/fmi2//reference/index.html) and
the following vignette:

- [Getting weather observation
  data](https://ropengov.github.io/fmi2//articles/weather_observation_data.html)

There are also the following articles:

- [Tutorial for fmi2 R package]()
- [Säähavaintojen hakeminen]()
- [Tutoriaali fmi2 R-paketille]()

## Contributing

If you have a particular need in mind, you’re free to:

1.  Fork the repository, modify the code and leave a pull request.
2.  Leave an [issue](https://github.com/rOpenGov/fmi2/issues) with a
    description on the improvements.

You can also leave bug reports at the [issues
page](https://github.com/rOpenGov/fmi2/issues).

## Why fmi2?

If this is `fmi2`, where’s the first `fmi`!? Good question, `fmi` can be
found [here](https://github.com/rOpenGov/fmi) and is no longer developed
or maintained. `fmi` was developed back in the day when accessing data
from a WFS in R was much more difficult. Hence, the package is much more
complicated than `fmi2` and too laborious to maintain.

## Acknowledgements

Kindly cite this work as follows: Joona Lehtomäki and Leo Lahti
(rOpenGov 2024). fmi2: Finnish Meteorological Institute open data API R
client. R package version 0.3.1. URL: <https://github.com/rOpenGov/fmi2>

We are grateful for all
[contributors](https://github.com/rOpenGov/fmi2/graphs/contributors).
This project is part of [rOpenGov](https://ropengov.org).

## Disclaimer

This package is in no way officially related to Finnish Meteorological
Institute (Ilmantieteen laitos, FMI).

For information about FMI’s open data lisence, please see their website:

- In English: [FMI’s open data
  lisence](https://en.ilmatieteenlaitos.fi/open-data-licence)
- In Finnish: [FMI:n avoimen datan
  lisenssi](https://www.ilmatieteenlaitos.fi/avoin-data-lisenssi)
