#' @title Daily weather observations
#' @description Daily weather observations from weather stations.
#'
#' @details Default set contains daily precipitation rate, mean temperature,
#' snow depth,
#' and minimum and maximum temperature. By default, the data is returned from
#' last 744 hours (31 days). At least one location parameter (geoid/place/fmisid/wmo/bbox)
#' has to be given.
#'
#' The FMI WFS stored query used by this function is
#' `fmi::observations::weather::daily::simple`. For more informations, see the
#' \href{https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services}{FMI documentation page}.
#'
#' @param starttime character or Date start of the time interval in ISO-format.
#'                  character will be coerced into a Date object.
#' @param endtime character or Date end of the time interval in ISO-format.
#'                character will be coerced into a Date object.
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
#' @importFrom checkmate assert check_null
#' @importFrom lubridate as_date
#'
#' @note For a complete description of the accepted arguments, see
#' `list_parameters("fmi::observations::weather::daily::simple")`.
#'
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. Following variables are returned:
#'   \describe{
#'     \item{TG_PT12H_min}{Ground minimum temperature (degC)}
#'     \item{rrday}{Precipitation amount (mm)}
#'     \item{snow}{Snow depth (cm)}
#'     \item{tday}{Average air temperature (degC)}
#'     \item{tmin}{Minimum air temperature (degC)}
#'     \item{tmax}{Maximum air temperature (degC)}
#'   }
#'
#' @export
#'
#' @seealso https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,
#' @seealso \link[fmi2]{list_parameters}
#'
obs_weather_daily <- function(starttime = NULL, endtime = NULL, fmisid = NULL, place = NULL,
                              parameters = NULL, crs = NULL, bbox = NULL, timestep = NULL) {

  # At least one location argument must be provided
  if (all(is.null(c(fmisid, place, bbox)))) {
    stop("No location argument provided", call. = FALSE)
  }

  # start and end time must be Dates or characters coercable to Dates, and must
  # be in the past

  # Format crs
  if(!is.null(crs)){
    crs <- paste0("EPSG::", crs)
  }

  # Check time arguments
  if (is.null(c(starttime, endtime))) {
    message("No time arguments given. Observations will be returned from the last 744 hours (31 days).")
  } else if (any(sapply(list(starttime, endtime), is.null))) {
    message("Only one of the time arguments given. Observations will be returned from the last 744 hours (31 days).")
    starttime <- NULL
    endtime <- NULL
  }

  fmi_obj <- fmi_api(request = "getFeature",
                     storedquery_id = "fmi::observations::weather::daily::simple",
                     starttime = starttime, endtime = endtime, parameters = parameters,
                     fmisid = fmisid, place = place, crs = crs, bbox = bbox, timestep = timestep)
  sf_obj <- to_sf(fmi_obj)
  sf_obj <- sf_obj %>%
    dplyr::select(time = .data$Time, variable = .data$ParameterName,
                  value = .data$ParameterValue) %>%
    dplyr::mutate(time = as.Date(.data$time),
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
