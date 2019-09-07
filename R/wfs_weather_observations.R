#' Get daily observations for a given locations.
#'
#' The FMI WFS stored query used by this function is
#' `fmi::observations::weather::daily::simple`. For more informations, see
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
#'        (see \link[fmi2]{fmi_stations}.
#' @param	maxlocations numeric maximum amount of locations.
#' @param geoid numeric geoid of the location for which to return data.
#' @param wmo numeric WMO code of the location for which to return data.
#'
#' @import dplyr
#'
#' @note For a complete description of the accepted arguments, see
#' `list_parameters("fmi::observations::weather::daily::simple")`.
#'
#' @return sf object
#'
#' @export
#'
#' @seealso https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,
#' @seealso \link[fmi2]{list_parameters}
#'
#' @examples
obs_weather_daily <- function(starttime, endtime, fmisid = NULL) {
  fmi_obj <- fmi_api(request = "getFeature",
                     storedquery_id = "fmi::observations::weather::daily::simple",
                     starttime = starttime, endtime = endtime, fmisid = fmisid)
  sf_obj <- to_sf(fmi_obj) %>%
    dplyr::select(time = Time, variable = ParameterName,
                  value = ParameterValue)
  return(sf_obj)
}
