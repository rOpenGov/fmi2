# List stored queries available over the FMI API.

Stored queries are identifiers for data sets. The current version on the
Open Data WFS service of the Finnish Meteorological Institute uses the
stored queries extensively to enable users to select the features, areas
and times they require as easily as possible. See [the Open data WFS
Service](https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services)
for more detailed information about the available stored queries and
their request parameters.

## Usage

``` r
list_queries(all = FALSE)
```

## Arguments

- all:

  logical should all stored queries available through the API be
  listed(default: FALSE)?

## Value

tibble containing the following columns:

- query_id:

  ID of the storied query.

- query_desc:

  Description of the storied query.

- no_parameters:

  Number of parameters.

- function_name:

  Name of the function in fmi2 if wrapped, NA otherwise.

## See also

https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services

## Author

Joona Lehtomäki <joona.lehtomaki@iki.fi>

## Examples

``` r
if (FALSE) { # \dontrun{
  # List the stored queres that have been wrapped (i.e. are accessible) by
  # the fmi2 package
  list_queries()
  # List all stored queries available through the API
  list_queries(all = TRUE)
} # }
```
