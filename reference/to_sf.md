# Transform a fmi_api object into a sf object.

FMI API response object's XML (GML) content is temporarily wrtitten on
disk and then immediately read back in into a sf object.

## Usage

``` r
to_sf(api_obj)
```

## Arguments

- api_obj:

  fmi api object

## Value

sf object

## Note

For internal use, not exported.

## See also

[fmi_api](https://ropengov.github.io/fmi2/reference/fmi_api.md)

## Author

Joona Lehtomäki <joona.lehtomaki@iki.fi>

## Examples

``` r
  if (FALSE) { # \dontrun{
    response <- fmi_api(request = "getFeature",
                        storedquery_id = "fmi::observations::weather::daily::timevaluepair",
                        starttime = "2019-01-01", endtime = "2019-01-04",
                        fmisid = 100946)
    sf_obj <- to_sf(response)
  } # }
```
