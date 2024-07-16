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
#' @importFrom checkmate assert check_null
#' @importFrom lubridate parse_date_time
#'
#' @note For a complete description of the accepted arguments, see
#' `list_parameters("fmi::observations::weather::monthly::simple")`.
#'
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. Following variables are returned:
#'   \describe{
#'     \item{rrmon}{Monthly precipitation amount (mm)}
#'     \item{tmon}{Monthly mean temperature (degC)}
#'   }
#'
#' @export
#'
#' @examples
#'   \dontrun{
#'     y <- obs_weather_monthly(starttime = "2024-01-01", endtime = "2024-05-01", place = "Turku" )
#' }
#'
#' @seealso https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,
#' @seealso \link[fmi2]{list_parameters}
#'
obs_weather_monthly <- function(starttime = NULL, endtime = NULL, fmisid = NULL, place = NULL,
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
    message("No time arguments given. Observations will be returned from the last 744 hours (31 days).")
  } else if (any(sapply(list(starttime, endtime), is.null))) {
    message("Only one of the time arguments given. Observations will be returned from the last 744 hours (31 days).")
    starttime <- NULL
    endtime <- NULL
  }

  if (!is.null(c(starttime, endtime))) {
    if (!valid_time(starttime, endtime)) {
      stop("Invalid time arguments")
    }
  }

  # Query for caching
  query <- list(
    type = "obs_weather_monthly",
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
                     storedquery_id = "fmi::observations::weather::monthly::simple",
                     starttime = starttime, endtime = endtime, parameters = parameters,
                     fmisid = fmisid, place = place, crs = crs, bbox = bbox, timestep = timestep,
                     geoid = geoid, wmo = wmo)
  sf_obj <- to_sf(fmi_obj)
  sf_obj <- sf_obj %>%
    dplyr::select(time = .data$Time, variable = .data$ParameterName,
                  value = .data$ParameterValue) %>%
    dplyr::mutate(time = as.Date(.data$time),
                  variable = as.character(.data$variable),
                  # Factor needs to be coerced into character first
                  value = as.numeric(as.character(.data$value))) %>%
    dplyr::mutate(value = ifelse(is.nan(.data$value), NA, .data$value))

  # Check for duplicated values
  sf_obj <- sf_obj %>%
    arrange(.data$time, .data$variable, is.na(.data$value)) %>%
    distinct(.data$time, .data$variable, .data$Location, .keep_all = TRUE)

  # Adding metadata into data.frame
  attr(sf_obj, "title") <- "Monthly weather observations"
  attr(sf_obj, "organization") <- "Finnish Meteorological Institute (FMI)"
  attr(sf_obj, "time_stamp") <- as.character(Sys.Date())
  attr(sf_obj, "parameters") <- parameters
  attr(sf_obj, "url") <- fmi_obj$url

  # Check if should be written in cache
  write_fmi2_cache(cache, cache_dir, query_hash, sf_obj, meta = TRUE)

  return(sf_obj)
}
