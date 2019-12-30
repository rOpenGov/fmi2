#' List and describe all valid parameters for a given stored query.
#'
#' For valid stored query IDs, see \code{\link[fmi2]{list_queries}}.
#'
#' @param query_id character string query ID.
#'
#' @importFrom purrr map
#' @import xml2
#'
#' @return a tibble describing the valid parameters.
#' @export
#'
#' @seealso \code{\link[fmi2]{list_queries}}.
#'
#' @author Joona Lehtomäki <joona.lehtomaki@@iki.fi>
#'
#' @examples
#'   \dontrun{
#'     list_parameters("fmi::observations::weather::daily::timevaluepair")
#'   }
list_parameters <- function(query_id) {

  api_obj <- fmi_api("DescribeStoredQueries")
  nodes <- api_obj$content

  # Check that the query ID provided is valid
  valid_ids <- unlist(purrr::map(nodes, xml2::xml_attr, attr = "id"))

  if (!query_id %in% valid_ids) {
    stop("Invalid query ID: ", query_id)
  }

  # Get the correct nodeset by selecing with the query ID
  param_nodes <- nodes %>%
    xml2::xml_find_all(xpath = paste0("//StoredQueryDescription[@id='",
                                      query_id, "']")) %>%
    xml2::xml_find_all(xpath = ".//Parameter")

  # Helper function to process each child node
  process_node <- function(node) {
    param_name <- xml2::xml_attr(node, attr = "name")
    param_type <- xml2::xml_attr(node, attr = "type")
    # Parameter title and abstract in plain language
    param_title <- node %>%
      xml2::xml_find_all("./Title") %>%
      xml2::xml_text()

    param_abstract <- node %>%
      xml2::xml_find_all("./Abstract") %>%
      xml2::xml_text()
    param_abstract <- gsub("[\r\n]", "", param_abstract)
    param_abstract <- trimws(param_abstract)

    # Collate all the data and return
    node_data <- tibble::tibble(
      param_name, param_type, param_title, param_abstract
    )
    return(node_data)
  }
  # Iterate over all child nodes (stored queries) and process them
  parameter_data <- purrr::map(param_nodes, process_node) %>%
    dplyr::bind_rows()
  return(parameter_data)
}
