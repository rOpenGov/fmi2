#' @title Get temperature observations
#' @description Temperature observations for different spatial resolutions.
#'
#' @details `get_temperature()` is a wrapper function for `obs_weather_monthly()`, `obs_weather_daily()`
#' and `obs_weather_hourly()`. User specifies which spatial resolution (hourly, daily or monthly)
#' they want the data in. At least one location parameter has to be given. The function can also
#' label variables by using `label_variables()` and add info on station(s) by using `add_station()`.
#'
#'
#' @param interval A character for the spatial resolution. `"hourly"` returns hourly observations,
#' `"daily"` returns daily observations and `"monthly"` returns monthly observations. The default value
#' is `"hourly"`.
#' @inheritParams obs_weather_hourly
#' @param label A logical for whether to label the variables. Default value is `FALSE`.
#' @param station A logical for whether to add station info into the data. Default value is `FALSE`.
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. The returned variables depend on the spatial resolution used.
#' * Hourly:
#'   \describe{
#'     \item{TA_PT1H_AVG}{Air temperature (degC)}
#'     \item{TA_PT1H_MAX}{Highest temperature (degC)}
#'     \item{TA_PT1H_MIN}{Lowest temperature (degC)}
#'   }
#' * Daily:
#' \describe{
#'     \item{TG_PT12H_min}{Ground minimum temperature (degC)}
#'     \item{tday}{Air temperature (degC)}
#'     \item{tmax}{Maximum temperature (degC)}
#'     \item{tmin}{Minimum temperature (degC)}
#'   }
#' * Monthly:
#' \describe{
#'     \item{tmon}{Monthly mean temperature}
#'   }
#' @export
#'
#' @examples
#'   \dontrun{
#'     # Hourly temperature values from Turku
#'     y <- get_temperature(interval = "hourly", place = "Turku", starttime = "2024-06-01",
#'                          endtime = "2024-06-07")
#'     # Daily temperature values from Helsinki
#'     y <- get_temperature(interval = "daily", place = "Helsinki", starttime = "2024-06-01",
#'                          endtime = "2024-07-01")
#'     # Monthly temperature values from Tampere
#'     y <- get_temperature(interval = "monthly", place = "Tampere", starttime = "2023-06-01",
#'                          endtime = "2024-06-01")
#'   }
get_temperature <- function(interval = "hourly", fmisid = NULL,
                            place = NULL, starttime = NULL, endtime = NULL,
                            crs = NULL, bbox = NULL, wmo = NULL, geoid = NULL, timestep = NULL,
                            label = FALSE, station = FALSE, cache = TRUE, cache_dir = NULL) {

  # Check that interval argument is right
  if (!interval %in% c("daily", "hourly", "monthly")) {
    stop("The interval argument ", interval, " is not recognized.")
  }

  # Get hourly temperature observations
  if (interval == "hourly") {

    y <- obs_weather_hourly(fmisid = fmisid, place = place, starttime = starttime,
                            endtime = endtime, crs = crs, bbox = bbox, wmo = wmo, geoid = geoid,
                            timestep = timestep, parameters = c(
                              "TA_PT1H_AVG", "TA_PT1H_MAX", "TA_PT1H_MIN"),
                            cache = cache, cache_dir = cache_dir)

  }

  # Get daily temperature observations
  if (interval == "daily") {

    y <- obs_weather_daily(fmisid = fmisid, place = place, starttime = starttime,
                           endtime = endtime, crs = crs, bbox = bbox, wmo = wmo, geoid = geoid,
                           timestep = timestep, parameters = c(
                             "TG_PT12H_min", "tday", "tmax", "tmin"),
                           cache = cache, cache_dir = cache_dir)

  }

  # Get monthly temperature observations
  if (interval == "monthly") {

    y <- obs_weather_monthly(fmisid = fmisid, place = place, starttime = starttime,
                           endtime = endtime, crs = crs, bbox = bbox, wmo = wmo, geoid = geoid,
                           timestep = timestep, parameters = c("tmon"),
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
