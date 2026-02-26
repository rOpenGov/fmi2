# FMI API

Requests to FMI API.

## Usage

``` r
fmi_api(request, storedquery_id = NULL, ...)
```

## Arguments

- request:

  character request type of either `DescribeStoredQueries` or
  `getFeature`.

- storedquery_id:

  character id of the stored query id. If `request` is `getFeature`,
  then `storedquery_id` must be provided and otherwise it's ignored.

- ...:

  stored query specific parameters. NOTE: it's up to the high-level
  functions to check the validity of the parameters.

## Value

fmi_api (S3) object with the following attributes:

- content:

  XML payload.

- path:

  path provided to get the resonse.

- response:

  the original response object.

## Details

Make a request to the FMI API. The base url is
opendata.fmi.fi/wfs?service=WFS&version=2.0.0 to which other components
defined by the arguments are appended.

This is a low-level function intended to be used by other higher level
functions in the package.

Note that GET requests are used using `httpcache` meaning that requests
are cached. If you want clear cache, use
[`httpcache::clearCache()`](https://enpiar.com/r/httpcache/reference/cache-management.html).
To turn the cache off completely, use
[`httpcache::cacheOff()`](https://enpiar.com/r/httpcache/reference/cache-management.html)

## Author

Joona Lehtomäki <joona.lehtomaki@iki.fi>

## Examples

``` r
  # List stored queries
  fmi_api(request = "DescribeStoredQueries")
#> $url
#> [1] "http://opendata.fmi.fi/wfs?service=WFS&version=2.0.0&request=DescribeStoredQueries"
#> 
#> $response
#> Response [http://opendata.fmi.fi/wfs?service=WFS&version=2.0.0&request=DescribeStoredQueries]
#>   Date: 2026-02-26 08:03
#>   Status: 200
#>   Content-Type: text/xml; charset=UTF-8
#>   Size: 467 kB
#> <?xml version="1.0" encoding="UTF-8"?>
#> <DescribeStoredQueriesResponse xmlns="http://www.opengis.net/wfs/2.0"
#>   xmlns:omso="http://inspire.ec.europa.eu/schemas/omso/3.0"
#>   xmlns:xlink="http://www.w3.org/1999/xlink"
#>   xmlns:ows_common="http://www.opengis.net/ows/1.1"
#>   xmlns:inspire_common="http://inspire.ec.europa.eu/schemas/common/1.0"
#>   xmlns:gml="http://www.opengis.net/gml/3.2"
#>   xmlns:fe="http://www.opengis.net/fes/2.0"
#>   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
#>   xsi:schemaLocation="http://www.opengis.net/wfs/2.0 http://schemas.opengis.n...
#> ...
#> 
#> $content
#> {xml_nodeset (160)}
#>  [1] <StoredQueryDescription id="ecmwf::forecast::pressure::grid">\n  <Title> ...
#>  [2] <StoredQueryDescription id="ecmwf::forecast::surface::cities::multipoint ...
#>  [3] <StoredQueryDescription id="ecmwf::forecast::surface::cities::simple">\n ...
#>  [4] <StoredQueryDescription id="ecmwf::forecast::surface::cities::timevaluep ...
#>  [5] <StoredQueryDescription id="ecmwf::forecast::surface::finland::grid">\n  ...
#>  [6] <StoredQueryDescription id="ecmwf::forecast::surface::grid">\n  <Title>E ...
#>  [7] <StoredQueryDescription id="ecmwf::forecast::surface::obsstations::multi ...
#>  [8] <StoredQueryDescription id="ecmwf::forecast::surface::obsstations::simpl ...
#>  [9] <StoredQueryDescription id="ecmwf::forecast::surface::obsstations::timev ...
#> [10] <StoredQueryDescription id="ecmwf::forecast::surface::point::multipointc ...
#> [11] <StoredQueryDescription id="ecmwf::forecast::surface::point::simple">\n  ...
#> [12] <StoredQueryDescription id="ecmwf::forecast::surface::point::timevaluepa ...
#> [13] <StoredQueryDescription id="fmi::ef::networks">\n  <Title>Environmental  ...
#> [14] <StoredQueryDescription id="fmi::ef::stations">\n  <Title>Environmental  ...
#> [15] <StoredQueryDescription id="fmi::forecast::climatology::scenario::grid"> ...
#> [16] <StoredQueryDescription id="fmi::forecast::edited::weather::scandinavia: ...
#> [17] <StoredQueryDescription id="fmi::forecast::edited::weather::scandinavia: ...
#> [18] <StoredQueryDescription id="fmi::forecast::edited::weather::scandinavia: ...
#> [19] <StoredQueryDescription id="fmi::forecast::edited::weather::scandinavia: ...
#> [20] <StoredQueryDescription id="fmi::forecast::enfuser::airquality::helsinki ...
#> ...
#> 
#> attr(,"class")
#> [1] "fmi_api"
```
