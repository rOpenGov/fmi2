# function fmi_station()

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
#' @importFrom dplyr bind_rows
#' @importFrom magrittr %>%
#' @importFrom purrr pluck
#' @importFrom rlang .data
#' @importFrom tibble tibble_row
#' @importFrom xml2 as_list
#'
#' @export
#'
#' @aliases fmi_weather_stations
#'
fmi_stations <- function() {

  # start and end time must be Dates or characters coercable to Dates, and must
  # be in the past

  fmi_obj <- fmi_api(request = "getFeature",
                     storedquery_id = "fmi::ef::stations") %>%
    purrr::pluck("content") %>%
    xml2::as_list()

  parse_nodes <- function(node) {
    # First level name in the list is a GML type. Store the value and get the
    # rest of the values (children nodes)n
    gml_type <- names(node)
    children <- purrr::pluck(node, 1)

    # The values of interest are a combination of actual list values and
    # attributes. More robust implementations would sniff out which one,
    # but here we rely on hard coded approach.

    # Station identifier
    fmisid <- purrr::pluck(children$identifier, 1)

    # Station name
    name <- purrr::pluck(children$name, 1)

    # Station type
    type <- attr(children$belongsTo, "title")

    # Location data. Get lat/long data
    point_data <- children$representativePoint$Point$pos %>%
      purrr::pluck(1) %>%
      strsplit(split = " ") %>%
      unlist()
    lat <- as.numeric(point_data[1])
    lon <- as.numeric(point_data[2])

    # Also get the EPSG code
    epsg <- attr(children$representativePoint$Point, "srsName") %>%
      strsplit(split = "/") %>%
      unlist() %>%
      tail(n = 1)

    # Operational activity period
    oap_start <- children$operationalActivityPeriod$OperationalActivityPeriod$activityTime$TimePeriod$beginPosition %>%
      purrr::pluck(1)
    oap_end <- children$operationalActivityPeriod$OperationalActivityPeriod$activityTime$TimePeriod$endPosition %>%
      attr("indeterminatePosition")

    station_data <- tibble::tibble_row(name, fmisid, type, lat, lon, epsg,
                                       oap_start, oap_end)
    return(station_data)
  }

  station_data <- purrr::map(fmi_obj[[1]], parse_nodes) %>%
    dplyr::bind_rows()
  return(station_data)
}
