# List and describe all valid parameters for a given stored query.

For valid stored query IDs, see
[`list_queries`](https://ropengov.github.io/fmi2/reference/list_queries.md).

## Usage

``` r
list_parameters(query_id)
```

## Arguments

- query_id:

  character string query ID.

## Value

a tibble describing the valid parameters.

## See also

[`list_queries`](https://ropengov.github.io/fmi2/reference/list_queries.md).

## Author

Joona Lehtomäki <joona.lehtomaki@iki.fi>

## Examples

``` r
  if (FALSE) { # \dontrun{
    list_parameters("fmi::observations::weather::daily::timevaluepair")
  } # }
```
