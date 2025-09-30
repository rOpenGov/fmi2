#' @title Plot weather stations
#' @description Plots weather stations on interactive map using `mapview::mapview()` function.
#'
#' @details The weather stations are plotted in layers based on the station type. Stations are
#' also colored by station type. User can click the points to get more info on the stations, for
#' example the station fmisid. Legends are plotted by default, which can cause problems on small
#' window. In this case it is recommended to set `legend = FALSE`.
#'
#' @param crs Character coordinate projection to use in results.
#' @param legend A logical for whether to add legends for weather station type to the map. Default
#' value is `TRUE`.
#' @importFrom mapview mapview
#' @importFrom sf st_as_sf
#'
#' @seealso [mapview::mapview()], which this function wraps.
#'
#' @export
#'
plot_stations <- function(crs = 4258, legend = TRUE){
  # nocov start
  # Get station data
  station_data <- fmi_stations()
  station_data <- station_data %>%
    sf::st_as_sf(coords = c("lon", "lat"), crs = 4258) %>%
    sf::st_transform(crs = crs)

  # Plot station data
  mapview::mapview(station_data, zcol = "type", burst = TRUE, homebutton = FALSE,
                   legend = legend, crs = crs)
  # nocov end
}


#' @title Select weather stations
#' @description Select weather functions from interactive map and return them in a sf object
#' that has data from the selected stations. This function calls the
#' `mapedit::selectFeatures()` function.
#'
#' @param crs character coordinate projection to use in results.
#' @importFrom sf st_as_sf
#' @importFrom mapedit selectFeatures
#'
#' @return sf object
#'
#' @seealso [mapedit::selectFeatures()], which this function wraps.
#'
#' @export
#'
#' @examples
#'   \dontrun{
#'     # Getting data from selected statons
#'     stations <- select_stations()
#'   }
#'
select_stations <- function(crs = 4258){
  # nocov start
  # Get station data
  station_data <- fmi_stations()
  station_data <- station_data %>%
    sf::st_as_sf(coords = c("lon", "lat"), crs = 4258)

  # Selecting stations
  stations <- mapedit::selectFeatures(station_data, label = ~c(paste0(fmisid, ": ", name)))
  stations <- stations %>%
    sf::st_transform(crs = crs)
  return(stations)
  # nocov end
}
