#' Daily weather observations from weather stations.
#'
#' Default set contains daily precipitation rate, mean temperature, snow depth,
#' and minimum and maximum temperature. By default, the data is returned from
#' last 744 hours. At least one location parameter (geoid/place/fmisid/wmo/bbox)
#' has to be given.
#'
#' The FMI WFS stored query used by this function is
#' `fmi::observations::weather::daily::simple`. For more informations, see
#' [the FMI documentation page](https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services).
#'
#' @param starttime character or Date start of the time interval in ISO-format.
#'                  character will be coerced into a Date object.
#' @param endtime character or Date end of the time interval in ISO-format.
#'                character will be coerced into a Date object.
# @param timestep numeric the time step of data in minutes.
# @param parameters character vector of parameters to return (see below).
# @param crs character coordinate projection to use in results.
# @param bbox numeric vector (EXAMPLE) bounding box of area for which to return
#'        data.
#' @param place character location name for which to provide data.
#' @param fmisid numeric FMI observation station identifier
#'        (see \link[fmi2]{fmi_stations}.
# @param	maxlocations numeric maximum amount of locations.
# @param geoid numeric geoid of the location for which to return data.
# @param wmo numeric WMO code of the location for which to return data.
#'
#' @import dplyr
#' @importFrom rlang .data
#' @importFrom checkmate assert check_null
#'
#' @note For a complete description of the accepted arguments, see
#' `list_parameters("fmi::observations::weather::daily::simple")`.
#'
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. Following variables are returned:
#'   \describe{
#'     \item{rrday}{Precipitation amount}
#'     \item{snow}{Snow depth}
#'     \item{tday}{Average air temperature}
#'     \item{tmin}{Minimum air temperature}
#'     \item{tmax}{Maximum air temperature}
#'     \item{TG_PT12H_min}{Ground minimum temperature}
#'   }
#'
#' @export
#'
#' @seealso https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,
#' @seealso \link[fmi2]{list_parameters}
#'
obs_weather_daily <- function(starttime, endtime, fmisid = NULL, place = NULL) {

  # At least one location argument must be provided
  if (is.null(fmisid) & is.null(place)) {
    stop("No location argument provided", call. = FALSE)
  }

  fmi_obj <- fmi_api(request = "getFeature",
                     storedquery_id = "fmi::observations::weather::daily::simple",
                     starttime = starttime, endtime = endtime, fmisid = fmisid,
                     place = place)
  sf_obj <- to_sf(fmi_obj)
  sf_obj <- sf_obj %>%
    dplyr::select(time = .data$Time, variable = .data$ParameterName,
                  value = .data$ParameterValue) %>%
    dplyr::mutate(time = as.Date(.data$time),
                  variable = as.character(.data$variable),
                  # Factor needs to be coerced into character first
                  value = as.numeric(as.character(.data$value))) %>%
    dplyr::mutate(value = ifelse(is.nan(.data$value), NA, .data$value))
  return(sf_obj)
}

#' Hourly weather observations from weather stations.
#'
#' Default set contains hourly air temperature average, maximum and minimum, air
#' relative humidity average, wind speed average, minumum (10 minute average)
#' and maximum (10 minute average), wind direction average, wind gust speed
#' maximum (3 second average), rain accumulated, rain intensity maximum, air
#' pressure average and the most significant weather code. By default, the data
#' is returned from last 24 hours. At least one location parameter
#' (geoid/place/fmisid/wmo/bbox) has to be given.
#'
#' The FMI WFS stored query used by this function is
#' `fmi::observations::weather::hourly::simple`. For more informations, see
#' [the FMI documentation page](https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services).
#'
#' @param starttime character begin of the time interval in ISO-format.
#' @param endtime character end of time interval in ISO-format.
# @param timestep numeric the time step of data in minutes.
# @param parameters character vector of parameters to return (see below).
# @param crs character coordinate projection to use in results.
# @param bbox numeric vector (EXAMPLE) bounding box of area for which to return
#'        data.
# @param place character location name for which to provide data.
#' @param fmisid numeric FMI observation station identifier
#'        (see \link[fmi2]{fmi_stations}.
# @param	maxlocations numeric maximum amount of locations.
# @param geoid numeric geoid of the location for which to return data.
# @param wmo numeric WMO code of the location for which to return data.
#'
#' @import dplyr
#' @importFrom lubridate parse_date_time
#'
#' @note For a complete description of the accepted arguments, see
#' `list_parameters("fmi::observations::weather::hourly::simple")`.
#'
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. Following variables are returned:
#'   \describe{
#'     \item{rrday}{Precipitation amount}
#'     \item{snow}{Snow depth}
#'     \item{tday}{Average air temperature}
#'     \item{tmin}{Minimum air temperature}
#'     \item{tmax}{Maximum air temperature}
#'     \item{TG_PT12H_min}{Ground minimum temperature}
#'   }
#'
#' @export
#'
#' @seealso https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,
#' @seealso \link[fmi2]{list_parameters}
#'
obs_weather_hourly <- function(starttime, endtime, fmisid = NULL) {
  fmi_obj <- fmi_api(request = "getFeature",
                     storedquery_id = "fmi::observations::weather::hourly::simple",
                     starttime = starttime, endtime = endtime, fmisid = fmisid)
  sf_obj <- to_sf(fmi_obj)
  sf_obj <- sf_obj %>%
    dplyr::select(time = .data$Time, variable = .data$ParameterName,
                  value = .data$ParameterValue) %>%
    dplyr::mutate(time = lubridate::parse_date_time(.data$time, "Ymd HMS"),
                  variable = as.character(.data$variable),
                  # Factor needs to be coerced into character first
                  value = as.numeric(as.character(.data$value))) %>%
    dplyr::mutate(value = ifelse(is.nan(.data$value), NA, .data$value))
  return(sf_obj)
}
