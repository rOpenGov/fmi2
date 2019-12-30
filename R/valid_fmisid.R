#' Check if a provided ID number is a valid FMI SID.
#'
#' \code{fmisid} is a ID numbering system used by the FMI.
#'
#' @param fmisid numeric or character ID number.
#'
#' @return logical
#'
#' @seealso \code{\link{fmi_stations}}
#'
#' @author Joona Lehtomaki \email{joona.lehtomaki@@gmail.com}
#' @export
#'
valid_fmisid <- function(fmisid) {
  if (is.null(fmisid)) {
    return(FALSE)
  } else {
    fmisid <- as.numeric(fmisid)
    stations <- fmi_stations()
    if (fmisid %in% stations$FMISID) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}
