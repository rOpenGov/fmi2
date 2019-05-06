#' fmi_api
#'
#' Make a request to the FMI API. The base url is
#' http://opendata.fmi.fi/wfs?service=WFS&version=2.0.0 to which other
#' components defined by the arguments are appended.
#'
#' This is a low-level function intended to be used by other higher level
#' functions in the package.
#'
#' Note that GET requests are used using `httpcache` meaning that requests
#' are cached. If you want clear cache, use [httpcache::clearCache()]. To turn
#' the cahce off completely, use [httpcache::cacheOff()]
#'
#' @param request character request type of either `DescribeStoredQueries` or
#'        `getFeature`.
#' @param storedquery_id character id of the stored query id. If `request` is
#'        `getFeature`, then `storedquery_id` must be provided and otherwise
#'        it's ignored.
#' @param ... stored query specific parameters. NOTE: it's up to the high-level
#'        functions to check the validity of the parameters.
#'
#' @importFrom httr content http_error http_type modify_url status_code user_agent
#' @importFrom httpcache GET
#' @importFrom xml2 read_xml
#'
#' @return fmi_api (S3) object with the following attributes:
#'        \describe{
#'           \item{content}{XML payload.}
#'           \item{path}{path provided to get the resonse.}
#'           \item{response}{the original response object.}
#'         }
#'
#' @export
#'
#' @examples
#'   # List stored queries
#'   fmi_api(request = "DescribeStoredQueries")
#'
fmi_api <- function(request, storedquery_id = NULL, ...) {
  # Set the user agent
  ua <- httr::user_agent("https://github.com/rOpenGov/fmi2")

  # Unmutable base URL
  base_url <- "http://opendata.fmi.fi/wfs"
  # Standard and compulsory query parameters
  base_queries <- list("service" = "WFS", "version" = "2.0.0")

  # Note that there should be at least one parameter: request type.
  queries <- append(base_queries, list(request = request))

  # All arguments contained in ... are used to construct the final URL.
  if (request == "DescribeStoredQueries") {
    if (!is.null(storedquery_id)) {
      warning("storedquery_id ignored as request type is DescribeStoredQueries",
              call. = FALSE)
    }
  } else if (request == "getFeature") {
    # TODO: raise error if storedquery_id is missing
    params <- append(queries, list(storedquery_id = storedquery_id, ...))
  } else {
    stop("Invalid request type: ", request)
  }

  # Construct the query URL
  url <- httr::modify_url(base_url, query = queries)

  # Get the response and check the response.
  resp <- httpcache::GET(url, ua)

  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "FMI API request failed [%s]",
        httr::status_code(resp)
      ),
      call. = FALSE
    )
  }

  api_obj <- structure(
    list(
      url = url,
      response = resp
    ),
    class = "fmi_api"
  )

  if (request == "DescribeStoredQueries") {
    # Parse the response XML content
    content <- xml2::read_xml(resp$content)
    # Strip the namespace as it will be only trouble
    xml2::xml_ns_strip(content)
    # Get all the child nodes
    nodes <- xml2::xml_children(content)
    # Attach the nodes to the API object
    api_obj$nodes <- nodes
  # getFeature is used for getting actual data
  } else if (request == "getFeature") {
    NULL
  } else {
    stop("Invalid request type: ", request)
  }

  return(api_obj)
}
