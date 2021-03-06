#' @title Describe FMI Variables
#' @description Describe FMI observation variable(s).
#'
#' @details FMI provides a machine-reabable (XML) description of different
#' observation variables. Use this function to see the specifications of a
#' given variable.
#'
#' @param x character vector of observation variables to be described.
#'
#' @return tibble containing the following columns:
#'   \describe{
#'     \item{variable}{Observation variable name}
#'     \item{label}{Variable (parameter) label used by the FMI}
#'     \item{base_phenomenon}{Base phenomenon that the variable is characterising}
#'     \item{unit}{Variabel unit}
#'     \item{stat_function}{Statistical function used the derive the variable value}
#'     \item{agg_period}{Aggregation time period}
#'   }
#'
#' @author Joona Lehtomäki <joona.lehtomaki@@iki.fi>
#'
#' @importFrom dplyr bind_rows
#' @importFrom glue glue
#' @importFrom httpcache GET
#' @importFrom purrr map
#' @importFrom tibble tibble
#' @importFrom xml2 xml_attr xml_children xml_name
#'
#' @export
#'
#' @examples
#'   \dontrun{
#'      desc <- describe_variables(c("TG_PT12H_min", "rrday"))
#'   }
describe_variables <- function(x) {

  # Get only unique values
  x <- unique(x)

  # Concatenate the requested variables
  vars <- paste0(x, collapse = ",")

  url <- glue::glue("https://opendata.fmi.fi/meta?observableProperty=observation&param={vars}&language=eng")

  # Set the user agent
  ua <- httr::user_agent("https://github.com/rOpenGov/fmi2")

  # Get the response and check the response.
  resp <- httr::GET(url, ua)
  # Parse the XML content
  content <- xml2::read_xml(resp$content)
  xml2::xml_ns_strip(content)

  # Process a single node (variable)
  process_node <- function(name, xml, multi = FALSE) {

    get_node_value <- function(nodes, root, leaf) {
      value <- xml2::xml_text(xml2::xml_find_first(nodes, paste0(root, leaf)))
      return(value)
    }

    get_node_attr <- function(nodes, root, leaf) {
      value <- xml2::xml_attr(xml2::xml_find_first(nodes, paste0(root, leaf)),
                              "uom")
      return(value)
    }

    variable <- name

    # <component> node is only returned if there are multiple variables
    root_node <- ""
    if (multi) {
      root_node <- "component/"
    }

    root <- glue::glue('//{root_node}ObservableProperty[@gml:id="{tolower(name)}"]')
    label <- get_node_value(xml, root, "//label")
    base_phenomenon <- get_node_value(xml, root, "//basePhenomenon")
    unit <- get_node_attr(xml, root, "//uom")
    stat_function <- get_node_value(xml, root, "//StatisticalMeasure//statisticalFunction")
    agg_period <- get_node_value(xml, root, "//StatisticalMeasure//aggregationTimePeriod")

    return(tibble::tibble(variable = variable, label = label,
                          base_phenomenon = base_phenomenon, unit = unit,
                          stat_function = stat_function,
                          agg_period = agg_period))
  }

  # Construct the description data
  desc_data <- purrr::map(x, process_node, xml = content,
                          multi = length(x) > 1) %>%
    dplyr::bind_rows()

  return(desc_data)
}
