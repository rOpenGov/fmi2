#' @title Get precipitation observations
#' @description Precipitation observations for different spatial resolutions.
#'
#' @details `get_precipitation()` is a wrapper function for `obs_weather_monthly()`, `obs_weather_daily()`
#' and `obs_weather_hourly()`. User specifies which spatial resolution (hourly, daily or monthly)
#' they want the data in. At least one location parameter has to be given. The function can also
#' label variables by using `label_variables()` and add info on station(s) by using `add_station()`.
#'
#'
#' @param interval A character for the spatial resolution. `"hourly"` returns hourly observations,
#' `"daily"` returns daily observations and `"monthly"` returns monthly observations. The default value
#' is `"hourly"`.
#' @inheritParams obs_weather_daily
#' @param label A logical for whether to label the variables. Default value is `FALSE`.
#' @param station A logical for whether to add station info into the data. Default value is `FALSE`.
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. One of following variables is returned, depending on which
#' spatial resolution is used:
#'   \describe{
#'     \item{PRA_PT1H_ACC}{Hourly precipitation amount (mm)}
#'     \item{rrday}{Daily precipitation amount (mm)}
#'     \item{rrmon}{Monthly precipitation amount (mm)}
#'   }
#' @export
#'
#' @examples
#'   \dontrun{
#'     # Hourly precipitation values from Turku
#'     y <- get_precipitation(interval = "hourly", place = "Turku", starttime = "2024-06-23",
#'                            endtime = "2024-06-30")
#'     # Daily precipitation values from Helsinki
#'     y <- get_precipitation(interval = "daily", place = "Helsinki", starttime = "2024-06-01",
#'                            endtime = "2024-07-01")
#'     # Monthly precipitation values from Pori
#'     y <- get_precipitation(interval = "monthly", place = "Pori", starttime = "2023-07-01",
#'                            endtime = "2024-07-01")
#'   }
get_precipitation <- function(interval = "hourly", fmisid = NULL,
                              place = NULL, starttime = NULL, endtime = NULL,
                              crs = NULL, bbox = NULL, wmo = NULL, geoid = NULL, timestep = NULL,
                              label = FALSE, station = FALSE, cache = TRUE, cache_dir = NULL){

  # Check that interval argument is right
  if (!interval %in% c("daily", "hourly", "monthly")) {
    stop("The interval argument ", interval, " is not recognized.")
  }

  # Get hourly precipitation

  if (interval == "hourly"){

    y <- obs_weather_hourly(fmisid = fmisid, place = place, starttime = starttime,
                            endtime = endtime, crs = crs, bbox = bbox, wmo = wmo, geoid = geoid,
                            timestep = timestep, parameters = "PRA_PT1H_ACC",
                            cache = cache, cache_dir = cache_dir)

  }
  # Get daily precipitation

  if (interval == "daily"){

    y <- obs_weather_daily(fmisid = fmisid, place = place, starttime = starttime,
                           endtime = endtime, crs = crs, bbox = bbox, wmo = wmo, geoid = geoid,
                           timestep = timestep, parameters = "rrday",
                           cache = cache, cache_dir = cache_dir)

  }

  # Monthly precipitation

  if (interval == "monthly") {

    y <- obs_weather_monthly(fmisid = fmisid, place = place, starttime = starttime,
                             endtime = endtime, crs = crs, bbox = bbox, wmo = wmo, geoid = geoid,
                             timestep = timestep, parameters = "rrmon",
                             cache = cache, cache_dir = cache_dir)

  }

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
