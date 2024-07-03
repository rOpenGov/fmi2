#' @title Get hourly wind observations
#' @description Retrieve hourly wind observations from weather stations.
#'
#' @details `get_wind()` is a wrapper function for `obs_weather_hourly()`. Function returns all wind
#' related parameters given by `obs_weather_hourly()`. At least one location parameter has to be given.
#' By default data is returned from the last 24 hours. The function can also
#' label variables by using `label_variables()` and add info on station(s) by using `add_station()`.
#'
#'
#' @inheritParams obs_weather_hourly
#' @param label A logical for whether to label the variables. Default value is `FALSE`.
#' @param station A logical for whether to add station info into the data. Default value is `FALSE`.
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. Following variables are returned:
#'   \describe{
#'     \item{WD_PT1H_AVG}{Wind direction (deg)}
#'     \item{WS_PT1H_AVG}{Wind speed (m/s)}
#'     \item{WS_PT1H_MAX}{Maximum wind speed (m/s)}
#'     \item{WS_PT1H_MIN}{Minimum wind speed (m/s)}
#'   }
#' @export
#'
#' @examples
#'   \dontrun{
#'     # Get wind data from Turku
#'     y <- get_wind(place = "Turku", starttime = "2024-06-23", endtime = "2024-06-30")
#'   }
get_wind <- function(fmisid = NULL, place = NULL, starttime = NULL, endtime = NULL,
                     crs = NULL, bbox = NULL, timestep = NULL, label = FALSE, station = FALSE){


  # Get hourly data
  y <- obs_weather_hourly(fmisid = fmisid, place = place, starttime = starttime,
                          endtime = endtime, crs = crs, bbox = bbox, timestep = timestep,
                          parameters = c("WD_PT1H_AVG", "WS_PT1H_AVG", "WS_PT1H_MAX", "WS_PT1H_MIN"))

  # Check if variables should be labeled
  if (label) {

    y <- y %>%
      label_variables()

  }

  # Check if station info should be added
  if (station) {

    y <- y %>%
      add_station(crs = crs)

  }

  # Return the data
  return(y)
}
