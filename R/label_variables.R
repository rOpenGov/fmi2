#' @title Label FMI variables
#' @description `label_variables()` adds labels for the FMI observation variables.
#'
#'
#' @param x The FMI dataset, which variables you want labeled.
#' @param replace A logical for whether to replace the variable values with the full label.
#' Default is `FALSE`, which adds a new column for the labels.
#'
#' @import dplyr
#'
#' @return sf object
#' @export
#'
#' @examples
#'   \dontrun{
#'   # Labels in their own column
#'   y <- obs_weather_monthly(place = "Turku")
#'   y <- label_variables(y)
#'
#'   # Labels replace variable values
#'   y <- obs_weather_monthly(place = "Turku")
#'   y <- label_variables(y, replace = TRUE)
#'   }
#'
#'
label_variables <- function(x, replace = FALSE){

  # Get dataset attributes
  attri <- attributes(x)

  var_desc <- describe_variables(x$variable)

  combined <- x %>%
    dplyr::left_join(var_desc %>%
                       dplyr::select(.data$variable, .data$label),
                     by = "variable")

  if (replace) {

    combined <- combined %>%
      dplyr::select(-.data$variable) %>%
      dplyr::rename(variable = .data$label)

  }

  # Reinsert metadata
  attr(combined, "title") <- attri$title
  attr(combined, "organization") <- attri$organization
  attr(combined, "time_stamp") <- attri$time_stamp
  attr(combined, "parameters") <- attri$parameters
  attr(combined, "url") <- attri$url

  return(combined)

}
