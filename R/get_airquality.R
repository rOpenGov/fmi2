#' @title Hourly air quality observations
#' @description Hourly air quality observations from Finnish municipalities.
#'
#' @details Default set contains 10 different air quality variables.
#' By default, the data is returned from the last 24 hours. At least one location
#' parameter (geoid/place/fmisid/wmo/bbox) has to be given.
#'
#' The FMI WFS stored query used by this function is
#' `urban::observations::airquality::hourly::simple`. For more informations, see
#' [the FMI documentation page](https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services).
#'
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
#' @param cache A logical whether to do caching. Default is `TRUE`.
#' @param cache_dir A path to to cache directory. `NULL` (default) creates a "fmi2" directory in
#' the temporary directory defined by base R [tempdir()] function and uses this directory to
#' cache data in.
#'
#' @import dplyr
#' @importFrom lubridate parse_date_time
#'
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. Following variables are returned:
#'   \describe{
#'     \item{AQINDEX_PT1H_avg}{Air quality index}
#'     \item{CO_PT1H_avg}{Carbon monoxide (ug/m3)}
#'     \item{NO2_PT1H_avg}{Nitrogen dioxide (ug/m3)}
#'     \item{NO_PT1H_avg}{Nitrogen monoxide (ug/m3)}
#'     \item{O3_PT1H_avg}{Ozone (ug/m3)}
#'     \item{PM10_PT1H_avg}{Particulate matter < 10 µm (ug/m3)}
#'     \item{PM25_PT1H_avg}{Particulate matter < 2.5 µm (ug/m3)}
#'     \item{QBCPM25_PT1H_AVG}{musta hiili (black coal) PM2.5 (ug/m3)}
#'     \item{SO2_PT1H_avg}{Sulphur dioxide (ug/m3)}
#'     \item{TRSC_PT1H_avg}{Odorous sulphur compounds (ugS/m3)}
#'   }
#' @export
#'
#' @examples
#'   \dontrun{
#'     # Get air quality observations from Turku
#'     y <- get_airquality(place = "Turku", starttime = "2024-06-23", endtime = "2024-06-30")
#'   }
#'
get_airquality <- function(starttime = NULL, endtime = NULL, fmisid = NULL, place = NULL,
                           parameters = NULL, crs = NULL, bbox = NULL, timestep = NULL,
                           cache = TRUE, cache_dir = NULL){

  # At least one location argument must be provided
  if (is.null(c(fmisid, place, bbox))) {
    stop("No location argument provided", call. = FALSE)
  }

  # Format crs
  if(!is.null(crs)){
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

  # Query for caching
  query <- list(
    type = "obs_weather_daily",
    starttime = starttime,
    endtime = endtime,
    fmisid = fmisid,
    place = place,
    parameters = parameters,
    crs = crs,
    bbox = bbox,
    timestep = timestep
  )
  query_hash <- fmi2_fixity(query)

  # Check if data is in cache
  check_cache <- read_fmi2_cache(cache, cache_dir, query_hash)
  if (!is.null(check_cache)) {
    return(check_cache)
  }

  fmi_obj <- fmi_api(request = "getFeature",
                     storedquery_id = "urban::observations::airquality::hourly::simple",
                     starttime = starttime, endtime = endtime, parameters = parameters,
                     fmisid = fmisid, place = place, crs = crs, bbox = bbox,
                     timestep = timestep)

  sf_obj <- to_sf(fmi_obj)
  sf_obj <- sf_obj %>%
    dplyr::select(time = .data$Time, variable = .data$ParameterName,
                  value = .data$ParameterValue) %>%
    dplyr::mutate(time = lubridate::parse_date_time(.data$time, "Ymd HMS"),
                  variable = as.character(.data$variable),
                  # Factor needs to be coerced into character first
                  value = as.numeric(as.character(.data$value))) %>%
    dplyr::mutate(value = ifelse(is.nan(.data$value), NA, .data$value))

  # Check for duplicated values
  sf_obj <- sf_obj %>%
    arrange(.data$time, .data$variable, is.na(.data$value)) %>%
    distinct(.data$time, .data$variable, .data$Location, .keep_all = TRUE)

  # Adding metadata into data.frame
  attr(sf_obj, "title") <- "Hourly air quality observations"
  attr(sf_obj, "organization") <- "Finnish Meteorological Institute (FMI)"
  attr(sf_obj, "time_stamp") <- as.character(Sys.Date())
  attr(sf_obj, "parameters") <- parameters
  attr(sf_obj, "url") <- fmi_obj$url

  # Check if should be written in cache
  write_fmi2_cache(cache, cache_dir, query_hash, sf_obj)

  return(sf_obj)
}
