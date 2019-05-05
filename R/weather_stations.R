# function fmi_station()

# Reading the local version included within the package is separated into its
# own function, since it's also used for tests.
.fmi_stations_local <- function() {
  message("Station list downloaded")
  system.file("extdata", "fmi_stations.csv", package = "fmi2") %>%
    utils::read.csv(as.is = TRUE) %>%
    tibble::as_tibble()
}

# Declare globalVariables to prevent check from complaining about
# NSE
utils::globalVariables(c("Elevation"))

# Use a closure for function fmi_station() in order to cache the results.
.fmi_stations_closure <- function() {

  cached_stations <- NULL

  function(groups = NULL, quiet = FALSE) {

    stations <- NULL

    if (!is.null(cached_stations)) {
      stations <- cached_stations
      message("Using cached stations")
    } else {
      tryCatch({
        station_url <- "http://en.ilmatieteenlaitos.fi/observation-stations"
        stations <- xml2::read_html(station_url) %>%
          rvest::html_table() %>%
          `[[`(1L) %>%
          tibble::as_tibble() %>%
          dplyr::mutate(
            Elevation = Elevation %>% sub(pattern = "\n.*$", replacement = "") %>%
          as.integer())

        # Groups can contain multiple values, but html_table() and
        # readHTMLable() both lose the separating '<br />'. Since group names
        # seem to start with an uppercase letter, use that to separate them.
        # It seems that the order in which they are returned can vary, so
        # sort them in alphabetical order to get consistent results
        # (important for the test that checks whether the included local copy
        # is still up-to-date with the online version).
        stations$Groups <- stations$Groups %>%
          strsplit("(?<=[a-z])(?=[A-Z])", perl = TRUE) %>%
          lapply(sort) %>%
          lapply(paste, collapse = ", ") %>%
          unlist()
        cached_stations <<- stations
        if (!quiet) {
          message("Station list downloaded from ", station_url)
        }
      }, error = function(e) {
        if (!quiet) {
          message("Error downloading from ", station_url)
        }
      })
    }
    if (is.null(stations)) {
      if (!quiet) {
        message("Using local copy instead.")
      }
      stations <- .fmi_stations_local()
    }
    if (!is.null(groups)) {
      indexes <- lapply(groups, grep, x = stations$Groups) %>%
        unlist() %>%
        sort() %>%
        unique()
      stations <- stations[indexes, ]
    }
    return(stations)
  }
}
#' Get a list of active FMI observation stations.
#'
#' A table of active observation stations is downloaded from the website of
#' Finnish Meteorological Institute, if package \pkg{rvest} or package \pkg{XML}
#' is installed. If neither is, or if the download fails for any other reason, a
#' local copy provided as a csv file within the \pkg{fmi} package is used.
#'
#' \code{fmi_weather_stations()} is a deprecated alias for
#' \code{fmi_stations(groups="Weather stations")}.
#'
#' @param groups a character vector of observation station groups to subset for
#' @param quiet whether to suppress printing of diagnostic messages
#'
#' @return a \code{data.frame} of active observation stations
#'
#' @seealso \url{http://en.ilmatieteenlaitos.fi/observation-stations}
#'
#' @author Joona Lehtomaki \email{joona.lehtomaki@@gmail.com},
#' Ilari Scheinin
#'
#' @importFrom magrittr %>%
#' @importFrom rvest html_table
#' @importFrom xml2 read_html
#'
#' @export
#'
#' @aliases fmi_weather_stations
#'
fmi_stations <- .fmi_stations_closure()

#' Check if a provided ID number is a valid FMI SID.
#'
#' \code{fmisid} is a ID numbering system used by the FMI.
#'
#' @param fmisid numeric or character ID number.
#'
#' @return logical
#'
#' @seealso \code{\link{fmi_stations}}
#'
#' @author Joona Lehtomaki \email{joona.lehtomaki@@gmail.com}
#' @export
#'
valid_fmisid <- function(fmisid) {
  if (is.null(fmisid)) {
    return(FALSE)
  } else {
    fmisid <- as.numeric(fmisid)
    stations <- fmi_stations()
    if (fmisid %in% stations$FMISID) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}
