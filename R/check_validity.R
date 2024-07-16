#' Check if a provided ID number is a valid FMI SID.
#'
#' \code{fmisid} is a ID numbering system used by the FMI.
#'
#' @param fmisid numeric or character ID number.
#'
#' @return logical
#'
#' @seealso \code{\link{fmi_stations}}
#' @keywords internal
#' @author Joona Lehtomaki \email{joona.lehtomaki@@gmail.com}
valid_fmisid <- function(fmisid) {
  if (is.null(fmisid)) {
    return(FALSE)
  } else {
    stations <- fmi_stations()
    if (all(fmisid %in% stations$fmisid)) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}


#' @title Check time arguments
#' @description Check that `starttime` and `endtime` arguments are valid.
#'
#' @param starttime character begin of the time interval in ISO-format.
#' @param endtime character end of the time interval in ISO-format.
#'
#' @importFrom lubridate parse_date_time
#'
#' @return logical
#' @keywords internal
valid_time <- function(starttime, endtime){

  # Read start and end time
  s_time <- suppressWarnings(lubridate::parse_date_time(starttime, c("Ymd", "Ymd HMS")))
  e_time <- suppressWarnings(lubridate::parse_date_time(endtime, c("Ymd", "Ymd HMS")))

  # Check that times are of valid format
  if (any(is.na(c(s_time, e_time)))) {
    message("Time arguments must be given in ISO-format.")
    return(FALSE)
  }

  # Check that start time is before end time
  if (s_time > e_time) {
    message("Start time is after end time.")
    return(FALSE)
  }
  return(TRUE)
}


#' @title Check place argument
#' @description Check that `place` argument is valid.
#'
#' @param place character location name.
#'
#' @return logical
#' @keywords internal
valid_place <- function(place){

  # Check place is not NULL and is valid
  if (is.null(place)) {
    return(FALSE)
  } else {
    # Get station data
    stations <- fmi_stations()
    if (length(place) > 1) {
      place_ok <- c()
      for (i in 1:length(place)) {
        if (sum(grepl(place[i], stations$name)) >= 1) {
          place_ok <- c(place_ok, TRUE)
        } else {
          place_ok <- c(place_ok, FALSE)
        }
      }
      if (all(place_ok)) {
        return(TRUE)
      } else {
        return(FALSE)
      }
    } else {
      if (sum(grepl(place, stations$name)) >= 1) {
        return(TRUE)
      } else {
        return(FALSE)
      }
    }
  }
}


#' @title Check crs argument
#' @description Check that `crs` argument is valid.
#'
#' @param crs character coordinate projection to use in results.
#'
#' @return logical
#' @keywords internal
valid_crs <- function(crs){
  # List of supported crs values
  crs_list <- c("", 3067, 4258, 3873, 3874, 3875, 3876, 3877, 3878, 3879, 3880,
                3881, 3882, 3883, 3884, 3885, 3046, 3047, 3048)
  # Check crs is valid
  if (crs %in% crs_list) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}


#' @title Check bbox argument
#' @description Check that `bbox` argument is valid.
#'
#' @param bbox
#'
#' @importFrom dplyr between
#' @return logical
#' @keywords internal
valid_bbox <- function(bbox){

  # Check bbox is valid
  if (inherits(bbox, "character")) {
    values <- as.numeric(unlist(strsplit(bbox, split = ",")))
    if (all(dplyr::between(values[c(1,3)], 15, 40)) && all(dplyr::between(values[c(2,4)], 50, 80))) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  } else if (inherits(bbox, "numeric")){
    if (all(dplyr::between(bbox[c(1,3)], 15, 40)) && all(dplyr::between(bbox[c(2,4)], 50, 80))) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}


#' @title Check timestep argument
#' @description Check that `timestep` argument is valid.
#'
#' @param timestep numeric, the time step of data in minutes.
#'
#' @return logical
#' @keywords internal
valid_timestep <- function(timestep){

  # Check that timestep is valid
  timestep <- suppressWarnings(as.numeric(timestep))
  if (is.na(timestep)) {
    message("Timestep must be a numeric")
    return(FALSE)
  } else if (timestep < 0) {
    message("Timestep can't be negative")
    return(FALSE)
  } else {
    return(TRUE)
  }
}


#' @title Check wmo argument
#' @description Check that `wmo` argument is valid.
#'
#' @param wmo numeric WMO code of the location for which to return data.
#'
#' @importFrom purrr pluck
#' @importFrom xml2 as_list
#'
#' @return logical
#' @keywords internal
valid_wmo <- function(wmo){

  # Check if wmo codes are in cache
  query <- list(type = "wmo list",
                download_date = Sys.Date())
  query_hash <- fmi2_fixity(query)
  cache_dir <- file.path(tempdir(), "fmi2")
  cache_dir <- path.expand(cache_dir)
  cache_file <- file.path(cache_dir, paste0(query_hash, ".rds"))
  if (dir.exists(cache_dir) && file.exists(cache_file)) {
    wmo_list <- readRDS(cache_file)
  } else {
    # Get list of wmo codes
    fmi_obj <- fmi_api(request = "getFeature",
                       storedquery_id = "fmi::ef::stations") %>%
      purrr::pluck("content") %>%
      xml2::as_list()

    obj <- fmi_obj[[1]]

    wmo_list <- c()

    for (j in seq_along(fmi_obj$FeatureCollection)){

      children <- purrr::pluck(obj, j)

      for (i in seq_along(children$EnvironmentalMonitoringFacility)) {
        attri <- attributes(children$EnvironmentalMonitoringFacility[[i]])
        attri <- ifelse(is.null(attri), "", attri)
        if (grepl("wmo", attri, ignore.case = TRUE)) {
          wmo_list <- c(wmo_list, children$EnvironmentalMonitoringFacility[[i]])
        }
      }
    }
    wmo_list <- as.numeric(unlist(wmo_list))

    # Write the list into cache
    if (!dir.exists(cache_dir)) {
      dir.create(cache_dir, recursive = TRUE)
    }
    saveRDS(wmo_list, file = cache_file, compress = TRUE)
}

  # Check that wmo is valid
  wmo <- as.numeric(wmo)
  if (all(wmo %in% wmo_list)) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}


#' @title Check geoid argument
#' @description Check that `geoid` argument is valid.
#'
#' @param geoid numeric geoid of the location for which to return data.
#'
#' @return logical
#'
#' @importFrom purrr pluck
#' @importFrom xml2 as_list
#'
#' @keywords internal
valid_geoid <- function(geoid){

  # Check if geoid codes are in cache
  query <- list(type = "geoid list",
                download_date = Sys.Date())
  query_hash <- fmi2_fixity(query)
  cache_dir <- file.path(tempdir(), "fmi2")
  cache_dir <- path.expand(cache_dir)
  cache_file <- file.path(cache_dir, paste0(query_hash, ".rds"))
  if (dir.exists(cache_dir) && file.exists(cache_file)) {
      geoid_list <- readRDS(cache_file)
    } else {
    # Get list of geoid codes
    fmi_obj <- fmi_api(request = "getFeature",
                       storedquery_id = "fmi::ef::stations") %>%
      purrr::pluck("content") %>%
      xml2::as_list()

    obj <- fmi_obj[[1]]

    geoid_list <- c()

    for (j in seq_along(fmi_obj$FeatureCollection)){

      children <- purrr::pluck(obj, j)

      for (i in seq_along(children$EnvironmentalMonitoringFacility)) {
        attri <- attributes(children$EnvironmentalMonitoringFacility[[i]])
        attri <- ifelse(is.null(attri), "", attri)
        if (grepl("geoid", attri, ignore.case = TRUE)) {
          geoid_list <- c(geoid_list, children$EnvironmentalMonitoringFacility[[i]])
        }
      }
    }
    geoid_list <-as.numeric(unlist(geoid_list))

    # Write the list into cache
    if (!dir.exists(cache_dir)) {
      dir.create(cache_dir, recursive = TRUE)
    }
    saveRDS(geoid_list, file = cache_file, compress = TRUE)
  }

  # Check that geoid is valid
  geoid <- as.numeric(geoid)
  if (all(geoid %in% geoid_list)) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
