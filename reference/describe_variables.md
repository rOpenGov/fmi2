# Describe FMI Variables

Describe FMI observation variable(s).

## Usage

``` r
describe_variables(x)
```

## Arguments

- x:

  character vector of observation variables to be described.

## Value

tibble containing the following columns:

- variable:

  Observation variable name

- label:

  Variable (parameter) label used by the FMI

- base_phenomenon:

  Base phenomenon that the variable is characterising

- unit:

  Variabel unit

- stat_function:

  Statistical function used the derive the variable value

- agg_period:

  Aggregation time period

## Details

FMI provides a machine-reabable (XML) description of different
observation variables. Use this function to see the specifications of a
given variable.

## Author

Joona Lehtomäki <joona.lehtomaki@iki.fi>

## Examples

``` r
  if (FALSE) { # \dontrun{
     desc <- describe_variables(c("TG_PT12H_min", "rrday"))
  } # }
```
