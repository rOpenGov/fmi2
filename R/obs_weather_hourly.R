#' @title Hourly weather observations
#' @description Hourly weather observations from weather stations.
#'
#' @details Default set contains hourly air temperature average, maximum and minimum, air
#' relative humidity average, wind speed average, minumum (10 minute average)
#' and maximum (10 minute average), wind direction average, wind gust speed
#' maximum (3 second average), rain accumulated, rain intensity maximum, air
#' pressure average and the most significant weather code. By default, the data
#' is returned from last 24 hours. The maximum time interval for observations is
#' 744 hours (31 days). At least one location parameter
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
#' @param bbox numeric vector (for example `c(22, 64, 24, 68)`) bounding box of area for
#'  which to return data.
#' @param place character location name for which to provide data.
#' @param fmisid numeric FMI observation station identifier
#'        (see \link[fmi2]{fmi_stations}).
# @param	maxlocations numeric maximum amount of locations.
#' @param geoid numeric geoid of the location for which to return data.
#' @param wmo numeric WMO code of the location for which to return data.
#' @param cache A logical whether to do caching. Default is `TRUE`.
#' @param cache_dir A path to to cache directory. `NULL` (default) creates a "fmi2" directory in
#' the temporary directory defined by base R [tempdir()] function and uses this directory to
#' cache data in.
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
#' @examples
#'   \dontrun{
#'   # Get hourly weather observations from Helsinki
#'   y <- obs_weather_hourly(place = "Helsinki", starttime = "2024-01-01", endtime = "2024-01-07")
#'   }
#'
obs_weather_hourly <- function(starttime = NULL, endtime = NULL, fmisid = NULL, place = NULL,
                               parameters = NULL, crs = NULL, bbox = NULL, timestep = NULL,
                               geoid = NULL, wmo = NULL, cache = TRUE, cache_dir = NULL) {

  # At least one location argument must be provided
  if (is.null(c(fmisid, place, bbox, geoid, wmo))) {
    stop("No location argument provided", call = FALSE)
  }

  # Check fmisid is valid
  if (!is.null(fmisid)) {
    if (!valid_fmisid(fmisid)) {
      stop("Invalid fmisid argument")
    }
  }

  # Check place is valid
  if (!is.null(place)) {
    if (!valid_place(place)) {
      stop("Invalid place argument")
    }
  }

  # Check geoid is valid
  if (!is.null(geoid)) {
    if (!valid_geoid(geoid)) {
      stop("Invalid geoid argument")
    }
  }

  # Check wmo is valid
  if (!is.null(wmo)) {
    if (!valid_wmo(wmo)) {
      stop("Invalid wmo valid")
    }
  }

  # Check bbox is valid
  if (!is.null(bbox)) {
    if (!valid_bbox(bbox)) {
      stop("Invalid bbox argument")
    }
  }

  # Check timestep is valid
  if (!is.null(timestep)) {
    if (!valid_timestep(timestep)) {
      stop("Invalid timestep argument")
    }
  }

  # Format crs
  if(!is.null(crs)){
    if (!valid_crs(crs)) {
      stop("Invalid crs argument")
    } else {
      crs <- paste0("EPSG::", crs)
    }
  }

  # Check time arguments
  if (is.null(c(starttime, endtime))) {
    message("No time arguments provided. Observations will be returned from the last 24 hours.")
  } else if (is.null(endtime)) {
    message("No end time provided. Observations will be returned from 744 hour (31 day) interval.")
    endtime <- as.character(as.Date(starttime) + 31)
  } else if (is.null(starttime)) {
    message("No start time provided. Observations will be returned from 744 hour (31 day) interval.")
    starttime <- as.character(as.Date(endtime) - 31)
  }

  if (!is.null(c(starttime, endtime))) {
    if (!valid_time(starttime, endtime)) {
      stop("Invalid time arguments")
    }
  }

  # Query for caching
  query <- list(
    type = "obs_weather_hourly",
    starttime = starttime,
    endtime = endtime,
    fmisid = fmisid,
    place = place,
    parameters = parameters,
    crs = crs,
    bbox = bbox,
    timestep = timestep,
    geoid = geoid,
    wmo = wmo,
    download_data = Sys.Date()
  )
  query_hash <- fmi2_fixity(query)

  # Check if data is in cache
  check_cache <- read_fmi2_cache(cache, cache_dir, query_hash, meta = TRUE)
  if (!is.null(check_cache)) {
    return(check_cache)
  }

  fmi_obj <- fmi_api(request = "getFeature",
                     storedquery_id = "fmi::observations::weather::hourly::simple",
                     starttime = starttime, endtime = endtime, parameters = parameters,
                     fmisid = fmisid, place = place, crs = crs, bbox = bbox, timestep = timestep,
                     geoid = geoid, wmo = wmo)
  sf_obj <- to_sf(fmi_obj)
  sf_obj <- sf_obj %>%
    dplyr::select(time = .data$Time, variable = .data$ParameterName,
                  value = .data$ParameterValue) %>%
    dplyr::mutate(time = lubridate::parse_date_time(.data$time, "Ymd HMS"),
                  variable = as.character(.data$variable),
                  # Factor needs to be coerced into character first
                  value = as.numeric(as.character(.data$value))) %>%
    dplyr::mutate(value = ifelse(is.nan(.data$value), NA, .data$value))

  # Adding metadata into data.frame
  attr(sf_obj, "title") <- "Hourly weather observations"
  attr(sf_obj, "organization") <- "Finnish Meteorological Institute (FMI)"
  attr(sf_obj, "time_stamp") <- as.character(Sys.Date())
  attr(sf_obj, "parameters") <- parameters
  attr(sf_obj, "url") <- fmi_obj$url

  # Check if should be written in cache
  write_fmi2_cache(cache, cache_dir, query_hash, sf_obj, meta = TRUE)

  return(sf_obj)
}
