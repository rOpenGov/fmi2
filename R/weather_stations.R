# function fmi_station()

# Use a closure for function fmi_station() in order to cache the results.
.fmi_stations_closure <- function() {

  cached_stations <- NULL

    function(url = "http://en.ilmatieteenlaitos.fi/observation-stations",
             quiet = FALSE) {

      stations <- NULL
      tryCatch({
        if (!is.null(cached_stations)) {
          stations <- cached_stations
          message("Using cached stations")
        } else {
          stations <- xml2::read_html(url) %>%
            rvest::html_table() %>%
            `[[`(1L) %>%
            tibble::as_tibble() %>%
            dplyr::mutate(
              Elevation = .data$Elevation %>% sub(pattern = "\n.*$", replacement = "") %>%
            as.integer())

          # Groups can contain multiple values, but html_table() and
          # readHTMLable() both lose the separating '<br />'. Since group names
          # seem to start with an uppercase letter, use that to separate them.
          # It seems that the order in which they are returned can vary, so
          # sort them in alphabetical order to get consistent results
          stations$Groups <- stations$Groups %>%
            strsplit("(?<=[a-z])(?=[A-Z])", perl = TRUE) %>%
            lapply(sort) %>%
            lapply(paste, collapse = ", ") %>%
            unlist()
          cached_stations <<- stations
          if (!quiet) {
            message("Station list downloaded from ", url)
          }
        }
        return(stations)
    }, error = function(e) {
      stop(e)
    })
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
#' @param url character URL where to look for the weather stations table
#' @param quiet logical whether to suppress printing of diagnostic messages
#'
#' @return a \code{data.frame} of active observation stations
#'
#' @seealso \url{http://en.ilmatieteenlaitos.fi/observation-stations}
#'
#' @author Joona Lehtomaki \email{joona.lehtomaki@@gmail.com},
#' Ilari Scheinin
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
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
