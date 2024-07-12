#' @title Cite a fmi2 dataset
#' @description Creates a bibliography for the selected fmi2 dataset.
#'
#' @param x fmi2 dataset to cite
#' @param format Default is "Biblatex", alternatives are "bibentry" or "Bibtex".
#' @param printCitation A logical whether to also print the citation. Default value is `TRUE`.
#'
#' @importFrom RefManageR BibEntry toBiblatex
#' @importFrom lubridate year
#' @importFrom utils person packageVersion toBibtex citation
#'
#' @return A Biblatex, bibentry or Bibtex object.
#'
#' @seealso [utils::bibentry()] [RefManageR::toBiblatex()]
#'
#' @examples
#'   \dontrun{
#'   # Example dataset
#'   y <- get_wind(place = "Turku", starttime = "2024-07-01", endtime = "2024-07-07")
#'   # Get citations
#'   cite_fmi2(y, format = "Biblatex")
#'   cite_fmi2(y, format = "bibtext")
#'   cite_fmi2(y, format = "bibentry")
#'   }
#'
#' @export
cite_fmi2 <- function(x, format = "Biblatex", printCitation = TRUE){

  format <- tolower(as.character(format))

  # Check format
  if (!format %in% c("bibentry", "bibtex", "biblatex")){
    warning("The ", format, " is not recognized. Will return Biblatex as default.")
    format <- "biblatex"
  }

  parameters <- paste(attr(x, "parameters"), collapse = ", ")

  ref <- RefManageR::BibEntry(
    bibtype = "Misc",
    title = attr(x, "title"),
    parameters = parameters,
    organization = attr(x, "organization"),
    author = utils::person(attr(x, "organization")),
    year = lubridate::year(attr(x, "time_stamp")),
    url = attr(x, "url"),
    type = "Dataset",
    note = paste0("Accessed ", attr(x, "time_stamp"), " using fmi2 R package ",
                  utils::packageVersion("fmi2")),
    textVersion = paste0(
      attr(x, "title"), " by ", attr(x, "organization"), ".\n", "Dataset accessed ",
      attr(x, "time_stamp"), " using fmi2 R package ", utils::packageVersion("fmi2"),
      ".\n", "Url: ", attr(x, "url"), "\n"
    )
  )

  if (format == "bibtex") {
    ref <- utils::toBibtex(ref)
  } else if (format == "biblatex") {
    ref <- RefManageR::toBiblatex(ref)
  }

  if (printCitation) {
  # Print citation
    if (format == "bibentry") {
      cat(ref$textVersion)
      print(utils::citation("fmi2"))
    } else {
      print(ref)
      print(utils::citation("fmi2"))
    }
  }

  # Return bibliography object
  invisible(ref)
}
