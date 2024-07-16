#' @title Add info for weather station(s)
#' @description `add_station()` adds info of the weather station into the FMI dataset.
#'
#' @param x The FMI dataset, which you want to add weather station info into.
#' @param crs The coordinate reference system to be used. The default value is `4258`,
#'  which is the default used by the FMI API.
#'
#' @import dplyr
#' @importFrom sf st_as_sf st_join st_nearest_feature st_transform
#'
#' @return sf object
#' @export
#'
#' @examples
#'   \dontrun{
#'   # With the default crs
#'   y <- obs_weather_monthly(place = "Helsinki")
#'   y <- add_station(y)
#'
#'   # With different crs
#'   y <- obs_weather_monthly(place = "Helsinki", crs = 3067)
#'   y <- add_station(y, crs = 3067)
#'   }
#'
add_station <- function(x, crs = 4258){

  # Get dataset attributes
  attri <- attributes(x)

  # Get weather station data
  stations <- fmi_stations() %>%
    dplyr::select(.data$name, .data$fmisid, .data$lat, .data$lon) %>%
    sf::st_as_sf(coords = c("lon", "lat"), crs = 4258) %>%
    sf::st_transform(crs = crs)

  # Join data
  y <- x %>%
    sf::st_join(stations, left = TRUE, join = sf::st_nearest_feature)

  y <- y %>%
    dplyr::rename(station_name = .data$name)

  # Reinsert metadata
  attr(y, "title") <- attri$title
  attr(y, "organization") <- attri$organization
  attr(y, "time_stamp") <- attri$time_stamp
  attr(y, "parameters") <- attri$parameters
  attr(y, "url") <- attri$url

  return(y)

}
