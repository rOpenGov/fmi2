#' List stored queries available over the FMI API.
#'
#' Stored queries are identifiers for data sets. The current version on the Open
#' Data WFS service of the Finnish Meteorological Institute uses the stored
#' queries extensively to enable users to select the features, areas and times
#' they require as easily as possible. See [the Open data WFS Service](https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services)
#' for more detailed information about the available stored queries and their
#' request parameters.
#'
#' @param all logical should all stored queries available through the API be
#'        listed(default: FALSE)?
#'
#' @import dplyr httpcache tibble xml2
#' @importFrom httr http_error
#' @importFrom purrr map
#'
#' @return tibble containing the following columns:
#' \describe{
#'   \item{query_id}{ID of the storied query.}
#'   \item{query_desc}{Description of the storied query.}
#'   \item{no_parameters}{Number of parameters.}
#'   \item{function_name}{Name of the function in fmi2 if wrapped, NA otherwise.}
#' }
#'
#' @export
#'
#' @seealso https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services
#'
#' @author Joona Lehtomäki <joona.lehtomaki@@iki.fi>
#'
#' @examples
#' \dontrun{
#'   # List the stored queres that have been wrapped (i.e. are accessible) by
#'   # the fmi2 package
#'   list_queries()
#'   # List all stored queries available through the API
#'   list_queries(all = TRUE)
#' }
#'
list_queries <- function(all = FALSE) {

  api_obj <- fmi_api("DescribeStoredQueries")
  nodes <- api_obj$content

  # Helper function to process each child node
  process_node <- function(node) {
    # Query ID is the technical descriptor used by the FMI
    query_id <- xml2::xml_attr(node, "id")
    # Query descrption in plain language
    query_desc <- node %>%
      xml2::xml_find_all("./Title") %>%
      xml2::xml_text()
    # Number of parameters for the given query
    no_parameters <- length(xml2::xml_name(xml2::xml_find_all(node, ".//Parameter")))
    # Corresponding function names in fmi2 will be processed later
    function_name <- NA
    # Collate all the data and return
    node_data <- tibble::tibble(
      query_id = query_id,
      query_desc = query_desc,
      no_parameters = no_parameters,
      function_name = function_name
    )
    return(node_data)
  }

  # Iterate over all child nodes (stored queries) and process them
  query_data <- purrr::map(nodes, process_node) %>%
    dplyr::bind_rows()

  find_function_name <- function(stored_query) {
    fname <- fmi2_global$function_map %>%
      dplyr::filter(.data$`Stored query` == stored_query) %>%
      dplyr::select(.data$`fmi2 function`) %>%
      dplyr::pull()
    fname <- ifelse(length(fname) == 0, NA, fname)
    return(fname)
  }
  # See which stored queries have a corresponding function in fmi2
  query_data$function_name <- purrr::map(query_data$query_id, find_function_name) %>%
    unlist()

  if (!all) {
    query_data <- query_data %>%
      dplyr::filter(!is.na(.data$function_name))
  }

  return(query_data)
}
