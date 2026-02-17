# Hourly weather observations from weather stations.

Default set contains hourly air temperature average, maximum and
minimum, air relative humidity average, wind speed average, minumum (10
minute average) and maximum (10 minute average), wind direction average,
wind gust speed maximum (3 second average), rain accumulated, rain
intensity maximum, air pressure average and the most significant weather
code. By default, the data is returned from last 24 hours. At least one
location parameter (geoid/place/fmisid/wmo/bbox) has to be given.

## Usage

``` r
obs_weather_hourly(starttime, endtime, fmisid = NULL)
```

## Arguments

- starttime:

  character begin of the time interval in ISO-format.

- endtime:

  character end of time interval in ISO-format. data.

- fmisid:

  numeric FMI observation station identifier (see
  [fmi_stations](https://ropengov.github.io/fmi2/reference/fmi_stations.md).

## Value

sf object in a long (melted) form. Observation variables names are given
in `variable` column. Following variables are returned:

- rrday:

  Precipitation amount

- snow:

  Snow depth

- tday:

  Average air temperature

- tmin:

  Minimum air temperature

- tmax:

  Maximum air temperature

- TG_PT12H_min:

  Ground minimum temperature

## Details

The FMI WFS stored query used by this function is
`fmi::observations::weather::hourly::simple`. For more informations, see
[the FMI documentation
page](https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services).

## Note

For a complete description of the accepted arguments, see
`list_parameters("fmi::observations::weather::hourly::simple")`.

## See also

https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,

[list_parameters](https://ropengov.github.io/fmi2/reference/list_parameters.md)
