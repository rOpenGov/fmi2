#' Decsribe FMI observation variable(s).
#'
#' FMI provides a machine-reabable (XML) description of different observation
#' variables. Use this function to see the specifications of a given variable.
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
#' @importFrom httr GET
#' @importFrom purrr map
#' @importFrom tibble tibble
#' @importFrom xml2 xml_attr xml_children xml_name
#'
#' @export
#'
#' @examples
#'   \dontrun{
#'      desc <- describe_variable(c("TG_PT12H_min", "rrday"))
#'   }
describe_variable <- function(x) {

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
  process_node <- function(name, xml) {

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

    # Get all the child nodes
    root <- glue::glue('//component/ObservableProperty[@gml:id="{tolower(name)}"]')
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
  desc_data <- purrr::map(x, process_node, xml = content) %>%
    dplyr::bind_rows()

  return(desc_data)
}

#' Transform a fmi_api object into a sf object.
#'
#' FMI API response object's XML (GML) content is temporarily wrtitten on disk
#' and then immediately read back in into a sf object.
#'
#' @param api_obj fmi api object
#'
#' @return sf object
#'
#' @importFrom sf st_read
#' @importFrom xml2 write_xml
#'
#' @note For internal use, not exported.
#'
#' @author Joona Lehtomäki <joona.lehtomaki@@iki.fi>
#'
#' @seealso \link[fmi2]{fmi_api}
#'
#' @examples
#'   \dontrun{
#'     response <- fmi_api(request = "getFeature",
#'                         storedquery_id = "fmi::observations::weather::daily::timevaluepair",
#'                         starttime = "2019-01-01", endtime = "2019-01-04",
#'                         fmisid = 100946)
#'     sf_obj <- to_sf(response)
#'   }
#'
to_sf <- function(api_obj) {
  if (!is(api_obj, "fmi_api")) {
    stop("Object provided must be of class fmi_api, not ", class(api_obj))
  }
  # Get response content
  content <- api_obj$content
  # Write the content to disk
  destfile <- paste(tempfile(), ".gml", sep = '')
  xml2::write_xml(content, destfile)

  # Read the temporary GML file back in
  features <- sf::st_read(destfile, quiet = TRUE)

  return(features)
}
