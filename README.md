<!-- README.md is generated from README.Rmd. Please edit that file -->

fmi2 - R client for the Finnish Meteorological Institute’s (FMI) API
====================================================================

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![codecov](https://codecov.io/gh/rOpenGov/fmi2/branch/master/graph/badge.svg)](https://codecov.io/gh/rOpenGov/fmi2)
[![CRAN
status](https://www.r-pkg.org/badges/version/fmi2)](https://CRAN.R-project.org/package=fmi2)
[![R build
status](https://github.com/rOpenGov/fmi2/workflows/R-CMD-check/badge.svg)](https://github.com/rOpenGov/fmi2/actions)
<!-- badges: end -->

R client package for [the Finnish Meteorological Institute (FMI) open
data API](https://en.ilmatieteenlaitos.fi/open-data-manual). `fmi2`
provides access to a subset of the FMI
[download](http://en.ilmatieteenlaitos.fi/open-data-manual-accessing-data)
service. FMI maintains and is reponsible for the data available through
their API, but has no official connections to `fmi2`.

All data from the FMI is released under [the Creative Commons
Attribution 4.0 International
license](https://creativecommons.org/licenses/by/4.0/).

Installation
------------

`fmi2` is not yet on CRAN, but you can install the development version
from [GitHub](https://github.com/rOpenGov/fmi2) with:

    # install.packages("remotes")
    remotes::install_github("rOpenGov/fmi2")

Details
-------

Currently, the following FMI stored queries are avaible in `fmi2`:

<table>
<colgroup>
<col style="width: 40%" />
<col style="width: 26%" />
<col style="width: 14%" />
<col style="width: 18%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Stored query</th>
<th style="text-align: left;">Description</th>
<th style="text-align: right;">No. parameters</th>
<th style="text-align: left;">fmi2 function name</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">fmi::observations::weather::daily::simple</td>
<td style="text-align: left;">Daily Weather Observations</td>
<td style="text-align: right;">11</td>
<td style="text-align: left;">obs_weather_daily</td>
</tr>
<tr class="even">
<td style="text-align: left;">fmi::observations::weather::hourly::simple</td>
<td style="text-align: left;">Hourly Weather Observations</td>
<td style="text-align: right;">12</td>
<td style="text-align: left;">obs_weather_hourly</td>
</tr>
</tbody>
</table>

More data sets and queries may be wrapped in the future.

Example
-------

For usage examples, see the package [function
reference](https://ropengov.github.io/fmi2/reference/index.html) and the
following vignettes:

-   [Getting weather observation
    data](https://ropengov.github.io/fmi2/articles/weather_observation_data.html)

Contributing
------------

If you have a particular need in mind, you’re free to:

1.  Fork the repository, modify the code and leave a pull request.
2.  Leave an [issue](https://github.com/rOpenGov/fmi2/issues) with a
    description on the improvements.

Why fmi2?
---------

If this is `fmi2`, where’s the first `fmi`!? Good question, `fmi` can be
found [here](https://github.com/rOpenGov/fmi) and is no longer developed
or maintained. `fmi` was developed back in the day when accessing data
from a WFS in R was much more difficult. Hence, the package is much more
complicated than `fmi2` and too laborious to maintain.
