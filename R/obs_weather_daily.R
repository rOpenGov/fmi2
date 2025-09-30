#' @title Daily weather observations
#' @description Daily weather observations from weather stations.
#'
#' @details Default set contains daily precipitation rate, mean temperature,
#' snow depth,
#' and minimum and maximum temperature. By default, the data is returned from
#' last 744 hours (31 days). The maximum time interval for observations is 8928 hours (372 days).
#' At least one location parameter (geoid/place/fmisid/wmo/bbox)
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
#' @importFrom dplyr select mutate arrange distinct
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
#' @examples
#'   \dontrun{
#'   # Get daily weather observations from Turku
#'   y <- obs_weather_daily(place = "Turku", starttime = "2024-01-01", endtime = "2024-02-01")
#'   }
#'
obs_weather_daily <- function(starttime = NULL, endtime = NULL, fmisid = NULL, place = NULL,
                              parameters = NULL, crs = NULL, bbox = NULL, timestep = NULL,
                              geoid = NULL, wmo = NULL, cache = TRUE, cache_dir = NULL) {

  # At least one location argument must be provided
  if (all(is.null(c(fmisid, place, bbox, geoid, wmo)))) {
    stop("No location argument provided", call. = FALSE)
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
    message("No time arguments provided. Observations will be returned from the last 744 hours (31 days).")
  } else if (is.null(endtime)) {
    message("No end time provided. Observations will be returned from 372 day interval.")
    endtime <- as.character(as.Date(starttime) + 372)
  } else if (is.null(starttime)) {
    message("No start time provided. Observations will be returned from 372 day interval.")
    starttime <- as.character(as.Date(endtime) - 372)
  }

  if (!is.null(c(starttime, endtime))) {
    if (!valid_time(starttime, endtime)) {
      stop("Invalid time arguments")
    }
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
    timestep = timestep,
    geoid = geoid,
    wmo = wmo,
    download_date = Sys.Date()
  )
  query_hash <- fmi2_fixity(query)

  # Check if data is in cache
  check_cache <- read_fmi2_cache(cache, cache_dir, query_hash, meta = TRUE)
  if (!is.null(check_cache)) {
    check_cache$time <- as.Date(check_cache$time)
    return(check_cache)
  }

  fmi_obj <- fmi_api(request = "getFeature",
                     storedquery_id = "fmi::observations::weather::daily::simple",
                     starttime = starttime, endtime = endtime, parameters = parameters,
                     fmisid = fmisid, place = place, crs = crs, bbox = bbox, timestep = timestep,
                     wmo = wmo, geoid = geoid)
  sf_obj <- to_sf(fmi_obj)
  sf_obj <- sf_obj %>%
    dplyr::select(time = "Time", variable = "ParameterName",
                  value = "ParameterValue") %>%
    dplyr::mutate(time = as.Date(.data$time),
                  variable = as.character(.data$variable),
                  # Factor needs to be coerced into character first
                  value = as.numeric(as.character(.data$value))) %>%
    dplyr::mutate(value = ifelse(is.nan(.data$value), NA, .data$value))

  # Check for duplicate values
  sf_obj <- sf_obj %>%
    dplyr::arrange(.data$time, .data$variable, is.na(.data$value)) %>%
    dplyr::distinct(.data$time, .data$variable, .data$Location, .keep_all = TRUE)

  # Adding metadata into data.frame
  attr(sf_obj, "title") <- "Daily weather observations"
  attr(sf_obj, "organization") <- "Finnish Meteorological Institute (FMI)"
  attr(sf_obj, "time_stamp") <- as.character(Sys.Date())
  attr(sf_obj, "parameters") <- parameters
  attr(sf_obj, "url") <- fmi_obj$url

  # Check if should be written in cache
  write_fmi2_cache(cache, cache_dir, query_hash, sf_obj, meta = TRUE)

  return(sf_obj)
}
