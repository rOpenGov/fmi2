# Weather observations

Daily weather observations from weather stations.

## Usage

``` r
obs_weather_daily(starttime, endtime, fmisid = NULL, place = NULL)
```

## Arguments

- starttime:

  character or Date start of the time interval in ISO-format. character
  will be coerced into a Date object.

- endtime:

  character or Date end of the time interval in ISO-format. character
  will be coerced into a Date object. data.

- fmisid:

  numeric FMI observation station identifier (see
  [fmi_stations](https://ropengov.github.io/fmi2/reference/fmi_stations.md).

- place:

  character location name for which to provide data.

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

Default set contains daily precipitation rate, mean temperature, snow
depth, and minimum and maximum temperature. By default, the data is
returned from last 744 hours. At least one location parameter
(geoid/place/fmisid/wmo/bbox) has to be given.

The FMI WFS stored query used by this function is
`fmi::observations::weather::daily::simple`. For more informations, see
the [FMI documentation
page](https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services).

## Note

For a complete description of the accepted arguments, see
`list_parameters("fmi::observations::weather::daily::simple")`.

## See also

https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,

[list_parameters](https://ropengov.github.io/fmi2/reference/list_parameters.md)
