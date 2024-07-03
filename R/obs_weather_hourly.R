#' @title Hourly weather observations
#' @description Hourly weather observations from weather stations.
#'
#' @details Default set contains hourly air temperature average, maximum and minimum, air
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
#' @param timestep numeric the time step of data in minutes.
#' @param parameters character vector of parameters to return (see below).
#' @param crs character coordinate projection to use in results.
#' @param bbox numeric vector (EXAMPLE) bounding box of area for which to return
#'        data.
#' @param place character location name for which to provide data.
#' @param fmisid numeric FMI observation station identifier
#'        (see \link[fmi2]{fmi_stations}).
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
#'     \item{PA_PT1H_AVG}{Air pressure (hPa)}
#'     \item{PRA_PT1H_ACC}{Precipitation amount (mm)}
#'     \item{PRI_PT1H_MAX}{Maximum precipitation intensity (mm/h)}
#'     \item{RH_PT1H_AVG}{Relative humidity (%)}
#'     \item{TA_PT1H_AVG}{Air temperature (degC)}
#'     \item{TA_PT1H_MAX}{Highest temperature (degC)}
#'     \item{TA_PT1H_MIN }{Lowest temperature (degC)}
#'     \item{WAWA_PT1H_RANK}{Present weather}
#'     \item{WD_PT1H_AVG }{Wind direction (deg)}
#'     \item{WS_PT1H_AVG }{Wind speed (m/s)}
#'     \item{WS_PT1H_MAX }{Maximum wind speed (m/s)}
#'     \item{WS_PT1H_MIN }{Minimum wind speed (m/s)}
#'   }
#'
#' @export
#'
#' @seealso https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,
#' @seealso \link[fmi2]{list_parameters}
#'
obs_weather_hourly <- function(starttime = NULL, endtime = NULL, fmisid = NULL, place = NULL,
                               parameters = NULL, crs = NULL, bbox = NULL, timestep = NULL) {

  # At least one location argument must be provided
  if (is.null(c(fmisid, place, bbox))) {
    stop("No location argument provided", call = FALSE)
  }

  # Format crs
  if (!is.null(crs)) {
    crs <- paste0("EPSG::", crs)
  }

  # Check time arguments
  if (is.null(c(starttime, endtime))) {
    message("No time arguments given. Observations will be returned from the last 24 hours.")
  } else if (any(sapply(list(starttime, endtime), is.null))) {
    message("Only one of the time arguments given. Observations will be returned from the last 24 hours.")
    starttime <- NULL
    endtime <- NULL
  }

  fmi_obj <- fmi_api(request = "getFeature",
                     storedquery_id = "fmi::observations::weather::hourly::simple",
                     starttime = starttime, endtime = endtime, parameters = parameters,
                     fmisid = fmisid, place = place, crs = crs, bbox = bbox, timestep = timestep)
  sf_obj <- to_sf(fmi_obj)
  sf_obj <- sf_obj %>%
    dplyr::select(time = .data$Time, variable = .data$ParameterName,
                  value = .data$ParameterValue) %>%
    dplyr::mutate(time = lubridate::parse_date_time(.data$time, "Ymd HMS"),
                  variable = as.character(.data$variable),
                  # Factor needs to be coerced into character first
                  value = as.numeric(as.character(.data$value))) %>%
    dplyr::mutate(value = ifelse(is.nan(.data$value), NA, .data$value))

  # Check for duplicate values
  sf_obj <- sf_obj %>%
    arrange(.data$time, .data$variable, is.na(.data$value)) %>%
    distinct(.data$time, .data$variable, .data$Location, .keep_all = TRUE)

  return(sf_obj)
}
