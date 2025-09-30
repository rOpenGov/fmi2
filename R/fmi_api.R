#' @title FMI API
#'
#' @description Requests to FMI API.
#'
#' @details Make a request to the FMI API. The base url is
#' opendata.fmi.fi/wfs?service=WFS&version=2.0.0 to which other
#' components defined by the arguments are appended.
#'
#' This is a low-level function intended to be used by other higher level
#' functions in the package.
#'
#' @param request character request type of either `DescribeStoredQueries` or
#'        `getFeature`.
#' @param storedquery_id character id of the stored query id. If `request` is
#'        `getFeature`, then `storedquery_id` must be provided and otherwise
#'        it's ignored.
#' @param ... stored query specific parameters. NOTE: it's up to the high-level
#'        functions to check the validity of the parameters.
#'
#' @importFrom httr2 url_parse url_build request req_user_agent req_error req_perform
#' resp_body_xml resp_status resp_status_desc req_retry
#' @importFrom xml2 read_xml xml_find_all xml_text xml_ns_strip xml_children
#'
#' @return fmi_api (S3) object with the following attributes:
#'        \describe{
#'           \item{content}{XML payload.}
#'           \item{url}{url to get the response.}
#'           \item{response}{the original response object.}
#'         }
#'
#' @export
#'
#' @author Joona Lehtomäki <joona.lehtomaki@@iki.fi>
#'
#' @examples
#'   \dontrun{
#'   # List stored queries
#'   fmi_api(request = "DescribeStoredQueries")
#'   }
#'
fmi_api <- function(request, storedquery_id = NULL, ...) {

  if (!request %in% c("DescribeStoredQueries", "getFeature")) {
    stop("Invalid request type: ", request)
  }

  # Set the user agent
  ua <- "https://github.com/rOpenGov/fmi2"

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
    # Check if storedquery_id is missing
    if (is.null(storedquery_id)) {
      stop("storedquery_id is missing.")
    }
    queries <- append(queries, list(storedquery_id = storedquery_id, ...))
  }

  # Check if there are several parameters arguments
  if (length(queries$parameters) > 1){
    para <- queries$parameters
    queries$parameters <- NULL
    for (i in 1:length(para)) {
      queries <- append(queries, list(parameters = para[i]))
    }
  }

  # Check if there are several place arguments
  if (length(queries$place) > 1){
    pla <- queries$place
    queries$place <- NULL
    for (i in 1:length(pla)) {
      queries <- append(queries, list(place = pla[i]))
    }
  }

  # Check if there are several fmisid arguments
  if (length(queries$fmisid) > 1){
    id <- queries$fmisid
    queries$fmisid <- NULL
    for (i in 1:length(id)) {
      queries <- append(queries, list(fmisid = id[i]))
    }
  }

  # Check if there are several geoid arguments
  if (length(queries$geoid) > 1){
    id <- queries$geoid
    queries$geoid <- NULL
    for (i in 1:length(id)) {
      queries <- append(queries, list(geoid = id[i]))
    }
  }

  # Check if there are several wmo arguments
  if (length(queries$wmo) > 1){
    id <- queries$wmo
    queries$wmo <- NULL
    for (i in 1:length(id)) {
      queries <- append(queries, list(wmo = id[i]))
    }
  }

  # Construct the query URL
  url_object <- httr2::url_parse(base_url)
  url_object$query <- queries
  final_url <- httr2::url_build(url_object)

  # Get the response and check the response.
  resp <- httr2::request(final_url) %>%
    httr2::req_user_agent(ua) %>%
    httr2::req_retry(max_tries = 3, max_seconds = 60) %>%
    httr2::req_error(is_error = function(resp) FALSE) %>%
    httr2::req_perform()

  # Parse the response xml content
  content <- resp %>%
    httr2::resp_body_xml()

  # Strip the namespace as it will be only trouble
  xml2::xml_ns_strip(content)

  if (httr2::resp_is_error(resp)) {
    status_code <- httr2::resp_status(resp)
    # If status code is 400, there might be more information available
    exception_texts <- ""
    if (status_code == 400) {
      exception_texts <- xml2::xml_text(xml2::xml_find_all(content, "//ExceptionText"))
      # Remove URI since full URL is going to be displayed
      exception_texts <- exception_texts[!grepl("^(URI)", exception_texts)]
      exception_texts <- c(exception_texts, paste("URL: ", final_url))
    }
    stop(
      sprintf(
        "FMI API request failed [%s (%i)]\n %s",
        httr2::resp_status_desc(resp),
        status_code,
        paste0(exception_texts, collapse = "\n ")
      ),
      call. = FALSE
    )
  }

  api_obj <- structure(
    list(
      url = final_url,
      response = resp
    ),
    class = "fmi_api"
  )

  if (request == "DescribeStoredQueries") {
    # Get all the child nodes
    nodes <- xml2::xml_children(content)
    # Attach the nodes to the API object
    api_obj$content <- nodes
    # getFeature is used for getting actual data
  } else if (request == "getFeature") {
    # Attach the nodes to the API object
    api_obj$content <- content
  }

  return(api_obj)
}
