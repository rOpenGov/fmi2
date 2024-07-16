# fmi2 (development version)

## CHANGES IN VERSION 0.3.1 (2024-07-16)

### NEW FEATURES
* Support for new stored queries in form of functions `obs_weather_monthly()`, gives monthly weather observations (issue #2, PR #23 by @Allaht2), and `get_airquality()`, gives hourly air quality observations.
* New wrapper functions `get_precipitation()`, `get_temperature()` and `get_wind()` for getting specific weather observations (issue #18, PR #23 by @Allaht2).
* Interactive function `fmi2_interactive()` for interactively getting data (issue #18, PR #23 by @Allaht2).
* Functions for interactively viewing and selecting weather stations: `plot_stations()` and `select_stations()` (issue #5, PR #23 by @Allaht2).
* Function `cite_fmi2()` added for citing `fmi2` datasets (issue #19, PR #23 by @Allaht2).
* Other new functions: `add_station()` and `label_variables()`.
* New depencies / imports: move from `httr` package to `httr2` package (issue #21, PR #23 by @Allaht2). Other new imports are `digest`, `mapedit`, `mapview` and `RefManageR`.
* Added support for data caching to data querying functions (issue #22, PR #23 by @Allaht2).

### DEPRECATED AND DEFUNCT
* Remove dependencies / imports: `httr`, `httpcache` and `rvest`.

### MINOR IMPROVEMENETS
* Update vignette and add Finnish version as article. Also add a new article going over new functions, Finnish version also included (issue #17, PR #23 by @Allaht2).
* Added support for arguments `parameters`, `crs`, `bbox`, `timestep`, `geoid`, and `wmo` to data querying functions.
* Update package citation information (issue #20, PR #23 by @Allaht2).
* Add functions for checking validity of arguments (issue #1, PR #23 by @Allaht2).


## CHANGES IN VERSION 0.2.0 (2020-11-29)

-   Use the FMI API to retrieve the FMI stations data. Previously this 
    information was retrieved by scraping a HTML table on the FMI
    webiste.

## CHANGES IN VERSION 0.1.1 (2019-XX-XX)

-   Remove local weather stations table (CSV). This means that FMI
    weather stations are downloaded from the FMI website once per each
    session. Table is no longer available when offline, but so are most
    of the data as well.

-   Man pages revised

### New features

### Bug fixes

-   Remove partial URL definition in the docs, as CRAN will error on
    these.

### Development related

-   Test coverage increased to 100%.
-   Internally, `fmi2_global$function_map` is now a tibble instead of a
    list.
-   Stored query / function -mapping in README is generated
    automatically with `list_queries()`.
-   Each function now lives in a file with the same name as the function
    (see [\#7](https://github.com/rOpenGov/fmi2/issues/7))

## CHANGES IN VERSION 0.1.0 (2019-09-09)

-   `fmi2` is here!
