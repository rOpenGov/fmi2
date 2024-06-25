#' @title Monthly weather observations
#' @description Monthly weather observations from weather stations.
#'
#' @details Default set contains monthly precipitation amount and monthly mean temperature.
#' By default, the data is returned from
#' last 12 months. At least one location parameter (geoid/place/fmisid/wmo/bbox)
#' has to be given.
#'
#' The FMI WFS stored query used by this function is
#' `fmi::observations::weather::monthly::simple`. For more informations, see the
#' \href{https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services}{FMI documentation page}.
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
#' @importFrom checkmate assert check_null
#' @importFrom lubridate parse_date_time
#'
#' @note For a complete description of the accepted arguments, see
#' `list_parameters("fmi::observations::weather::monthly::simple")`.
#'
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. Following variables are returned:
#'   \describe{
#'     \item{rrmon}{Monthly precipitation amount}
#'     \item{tmon}{Monthly mean temperature}
#'   }
#'
#' @export
#'
#' @seealso https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,
#' @seealso \link[fmi2]{list_parameters}
#'
obs_weather_monthly <- function(starttime, endtime, fmisid = NULL, place = NULL) {

  # At least one location argument must be provided
  if (is.null(fmisid) & is.null(place)) {
    stop("No location argument provided", call. = FALSE)
  }

  # start and end time must be Dates or characters coercable to Dates, and must
  # be in the past

  fmi_obj <- fmi_api(request = "getFeature",
                     storedquery_id = "fmi::observations::weather::monthly::simple",
                     starttime = starttime, endtime = endtime, fmisid = fmisid,
                     place = place)
  sf_obj <- to_sf(fmi_obj)
  sf_obj <- sf_obj %>%
    dplyr::select(time = Time, variable = ParameterName,
                  value = ParameterValue) %>%
    dplyr::mutate(time = as.Date(time),
                  variable = as.character(variable),
                  # Factor needs to be coerced into character first
                  value = as.numeric(as.character(value))) %>%
    dplyr::mutate(value = ifelse(is.nan(value), NA, value))
  return(sf_obj)
}
