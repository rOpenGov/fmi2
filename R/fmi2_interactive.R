#' @title Interactive function for fmi2
#' @description Interactive function for getting data from the different functions of
#'  `fmi2` package.
#'
#' @details The function allows user to interactively get observations from different `fmi2`
#' functions. The function also allows printing dataset citation, the function call used for
#' getting the data and a fixity checksum. Function can also add variable labels and station
#' information to the dataset.
#'
#' @importFrom utils menu capture.output
#'
#' @return sf object in a long (melted) form.
#' @export
#'
#' @examples
#'   \dontrun{
#'     y <- fmi2_interactive()
#'   }
fmi2_interactive <- function(){

  # Selecting which observations user wants
  obs_type <- switch(
    menu(c("Weather observations", "Temperature observations", "Wind observations",
           "Precipitation observations", "Airquality observations"),
         title = "Which observations do you want?") + 1,
    return(invisible()),
    "obs",
    "temp",
    "wind",
    "prec",
    "air"
  )

  # Selecting spatial resolution
  if (obs_type %in% c("obs", "temp", "prec")) {
    hourly <- FALSE
    daily <- FALSE
    monthly <- FALSE
    switch(
      menu(c("Hourly", "Daily", "Monthly"),
           title = "Select spatial resolution") + 1,
      return(invisible()),
      hourly <- TRUE,
      daily <- TRUE,
      monthly <- TRUE
    )
  }

  # Selecting starttime and endtime
  times_ok <- NULL
  while (is.null(times_ok)) {
    starttime <- readline(prompt = "Give start time in ISO-format: ")
    endtime <- readline(prompt = "Give end time: ")
    # Check time arguments are valid
    if (!valid_time(starttime, endtime)) {
      message("Plase give time in right format, yyyy-mm-dd")
    } else if (valid_time(starttime, endtime)) {
      times_ok <- TRUE
    }}

  # Select the way of choosing location
  location_selection <- switch(
    menu(c("Input parameter", "Select from interactive map"),
         title = "Select the way of choosing location") + 1,
    return(invisible()),
    "para",
    "map"
  )

  if (location_selection == "para") {
    # Selecting location parameter
    location_type <- switch(
      menu(c("place", "fmisid", "wmo", "geoid", "bbox"),
           title = "Select location parameter") + 1,
      return(invisible()),
      "place",
      "fmisid",
      "wmo",
      "geoid",
      "bbox"
    )

    # Check which location parameter to use
    if (location_type == "place") {
      place_ok <- NULL
      while( is.null(place_ok)) {
        place <- readline(prompt = "Enter place name for the station: ")
        # Check place
        if (!valid_place(place)) {
          message("Invalid place")
        } else if (valid_place(place)){
          place_ok <- TRUE
        }}
    } else {
      place <- NULL
    }

    if (location_type == "fmisid") {
      fmi_ok <- NULL
      while (is.null(fmi_ok)){
        fmisid <- readline(prompt = "Enter station fmisid: ")
        # Check fmisid
        if (!valid_fmisid(fmisid)) {
          message("Invalid fmisid")
        } else if (valid_fmisid(fmisid)) {
          fmi_ok <- TRUE
        }}
    } else {
      fmisid <- NULL
    }

    if (location_type == "wmo") {
      wmo_ok <- NULL
      while (is.null(wmo_ok)){
        wmo <- readline(prompt = "Enter station wmo: ")
        # Check wmo
        if (!valid_wmo(wmo)) {
          message("Invalid wmo")
        } else if (valid_wmo(wmo)) {
          wmo_ok <- TRUE
        }}
    } else {
      wmo <- NULL
    }

    if (location_type == "geoid") {
      geoid_ok <- NULL
      while (is.null(geoid_ok)){
        geoid <- readline(prompt = "Enter station geoid: ")
        # Check geoid
        if (!valid_geoid(geoid)) {
          message("Invalid geoid")
        } else if (valid_geoid(geoid)) {
          geoid_ok <- TRUE
        }}
    } else {
      geoid <- NULL
    }

    if (location_type == "bbox") {
      bbox_ok <- NULL
      while (is.null(bbox_ok)) {
        message("Enter coordinates in form of MinX,MinY,MaxX,MaxY")
        bbox <- readline(prompt = "Enter bounding box coordinates: ")
        # Check bbox
        if (!valid_bbox(bbox)) {
          message("Invalid bbox argument")
        } else if (valid_bbox(bbox)) {
          bbox_ok <- TRUE
        }}
    } else {
      bbox <- NULL
    }

  } else if (location_selection == "map") {
    stations <- select_stations()
    fmisid <- c(stations$fmisid)
    place <- NULL
    bbox <- NULL
  }

  # Ask if user wants to specify crs
  crs_select <- switch(
    menu(c("Yes", "No"),
         title = "Do you want to specify coordinate reference system (crs)?") + 1,
    return(invisible()),
    TRUE,
    FALSE
  )
  if (crs_select){
    # Selecting crs
    crs_ok <- NULL
    while(is.null(crs_ok)){
      crs <- readline(prompt = "Enter crs, nothing for default: " )
      # Check crs
      if (crs == ""){
        crs <- NULL
        crs_ok <- TRUE
      } else if (!valid_crs(crs)){
        message("Invalid crs")
      } else if (valid_crs(crs)){
        crs_ok <- TRUE
      }}
  } else {
    crs <- NULL
  }

  # Ask if user wants to specify timestep
  timestep_select <- switch(
    menu(c("Yes", "No"),
           title = "Do you want to specify timestep?") + 1,
    return(invisible()),
    TRUE,
    FALSE
  )
  if (timestep_select) {
    # Selecting timestep
    timestep_ok <- NULL
    while(is.null(timestep_ok)){
      timestep <- readline(prompt = "Enter timestep, nothing for default: ")
      # Check timestep
      if (timestep == ""){
        timestep <- NULL
        timestep_ok <- TRUE
      } else if (!valid_timestep(timestep)) {
        message("Invalid timestep")
      } else if (valid_timestep(timestep)) {
        timestep_ok <- TRUE
      }}
  } else {
    timestep <- NULL
  }

  # Getting the right data

  # Getting weather observations
  if (obs_type == "obs") {
    if (hourly) {
      y <- obs_weather_hourly(starttime = starttime, endtime = endtime, place = place,
                              fmisid = fmisid, crs = crs, bbox = bbox,
                              wmo = wmo, geoid = geoid, timestep = timestep)
      y_print <- substitute(
        obs_weather_hourly(starttime = starttime, endtime = endtime, place = place,
                           fmisid = fmisid, crs = crs, bbox = bbox,
                           wmo = wmo, geoid = geoid, timestep = timestep),
        list(starttime = starttime, endtime = endtime, place = place, fmisid = fmisid,
             crs = crs, bbox = bbox, wmo = wmo, geoid = geoid, timestep = timestep))
    } else if (daily) {
      y <- obs_weather_daily(starttime = starttime, endtime = endtime, place = place,
                             fmisid = fmisid, crs = crs, bbox = bbox,
                             wmo = wmo, geoid = geoid, timestep = timestep)
      y_print <- substitute(
        obs_weather_daily(starttime = starttime, endtime = endtime, place = place,
                          fmisid = fmisid, crs = crs, bbox = bbox,
                          wmo = wmo, geoid = geoid, timestep = timestep),
        list(starttime = starttime, endtime = endtime, place = place, fmisid = fmisid,
             crs = crs, bbox = bbox, wmo = wmo, geoid = geoid, timestep = timestep))
    } else if (monthly) {
      y <- obs_weather_monthly(starttime = starttime, endtime = endtime, place = place,
                               fmisid = fmisid, crs = crs, bbox = bbox,
                               wmo = wmo, geoid = geoid, timestep = timestep)
      y_print <- substitute(
        obs_weather_monthly(starttime = starttime, endtime = endtime, place = place,
                            fmisid = fmisid, crs = crs, bbox = bbox,
                            wmo = wmo, geoid = geoid, timestep = timestep),
        list(starttime = starttime, endtime = endtime, place = place, fmisid = fmisid,
             crs = crs, bbox = bbox, wmo = wmo, geoid = geoid, timestep = timestep))
    }
  }

  # Getting temperature data
  if (obs_type == "temp") {
    y <- get_temperature(hourly = hourly, daily = daily, monthly = monthly,
                         starttime = starttime, endtime = endtime, place = place,
                         fmisid = fmisid, crs = crs, bbox = bbox,
                         wmo = wmo, geoid = geoid, timestep = timestep)
    y_print <- substitute(
      get_temperature(hourly = hourly, daily = daily, monthly = monthly,
                      starttime = starttime, endtime = endtime, place = place,
                      fmisid = fmisid, crs = crs, bbox = bbox,
                      wmo = wmo, geoid = geoid, timestep = timestep),
      list(hourly = hourly, daily = daily, monthly = monthly, starttime = starttime,
           endtime = endtime, place = place, fmisid = fmisid, crs = crs, bbox = bbox,
           wmo = wmo, geoid = geoid, timestep = timestep))
  }

  # Getting wind data
  if (obs_type == "wind") {
    y <- get_wind(starttime = starttime, endtime = endtime, place = place,
                  fmisid = fmisid, crs = crs, bbox = bbox,
                  wmo = wmo, geoid = geoid, timestep = timestep)
    y_print <- substitute(
      get_wind(starttime = starttime, endtime = endtime, place = place,
               fmisid = fmisid, crs = crs, bbox = bbox,
               wmo = wmo, geoid = geoid, timestep = timestep),
      list(starttime = starttime, endtime = endtime, place = place, fmisid = fmisid,
           crs = crs, bbox = bbox, wmo = wmo, geoid = geoid, timestep = timestep))
  }

  # Getting precipitation data
  if (obs_type == "prec") {
    y <- get_precipitation(hourly = hourly, daily = daily, monthly = monthly,
                           starttime = starttime, endtime = endtime, place = place,
                           fmisid = fmisid, crs = crs, bbox = bbox,
                           wmo = wmo, geoid = geoid, timestep = timestep)
    y_print <- substitute(
      get_precipitation(hourly = hourly, daily = daily, monthly = monthly,
                        starttime = starttime, endtime = endtime, place = place,
                        fmisid = fmisid, crs = crs, bbox = bbox,
                        wmo = wmo, geoid = geoid, timestep = timestep),
      list(hourly = hourly, daily = daily, monthly = monthly, starttime = starttime,
           endtime = endtime, place = place, fmisid = fmisid, crs = crs, bbox = bbox,
           wmo = wmo, geoid = geoid, timestep = timestep))
  }

  # Getting air quality data
  if (obs_type == "air") {
    y <- get_airquality(starttime = starttime, endtime = endtime, place = place,
                        fmisid = fmisid, crs = crs, bbox = bbox,
                        wmo = wmo, geoid = geoid, timestep = timestep)
    y_print <- substitute(
      get_airquality(starttime = starttime, endtime = endtime, place = place,
                     fmisid = fmisid, crs = crs, bbox = bbox,
                     wmo = wmo, geoid = geoid, timestep = timestep),
      list(starttime = starttime, endtime = endtime, place = place, fmisid = fmisid,
           crs = crs, bbox = bbox, wmo = wmo, geoid = geoid, timestep = timestep))
  }

  # Should label be added
  lab <- switch(
    menu(c("Yes", "No"),
         title = "Add labels for variables?") + 1,
    return(invisible()),
    TRUE,
    FALSE
  )

  if (lab) {
    y <- y %>%
      label_variables()
  }

  # Should station be added
  station <- switch(
    menu(c("Yes", "No"),
         title = "Add station info?") + 1,
    return(invisible()),
    TRUE,
    FALSE
  )

  if (station) {
    y <- y %>%
      add_station()
  }

  # Should citation be printed
  print_citation <- switch(
    menu(c("Yes", "No"),
         title = "Print dataset citation?") + 1,
    return(invisible()),
    TRUE,
    FALSE
  )

  # Should code be printed
  print_code <- switch(
    menu(c("Yes", "No"),
         title = "Print the code for the function call?") + 1,
    return(invisible()),
    TRUE,
    FALSE
  )

  # Should fixity be printed
  print_fixity <- switch(
    menu(c("Yes", "No"),
         title = "Print fixity checksum for the data?") + 1,
    return(invisible()),
    TRUE,
    FALSE
  )

  # Tempfile for citation and function call code
  if (print_citation || print_code || print_fixity) {
    tempfile_for_sink <- tempfile()
  }

  # Write citation info
  if (print_citation) {
    citation <- cite_fmi2(y, printCitation = FALSE)
    capture.output(cat("#### DATASET CITATION \n\n"),
                   file = tempfile_for_sink, append = TRUE)
    capture.output(citation,
                   file = tempfile_for_sink, append = TRUE)
    capture.output(cat("\n"),
                   file = tempfile_for_sink, append = TRUE)
  }

  # Write code info
  if (print_code) {
    capture.output(cat("#### DOWNLOAD PARAMETERS: \n\n"),
                   file = tempfile_for_sink, append = TRUE)
    capture.output(y_print,
                   file = tempfile_for_sink, append = TRUE)
    capture.output(cat("\n"),
                   file = tempfile_for_sink, append = TRUE)
  }

  # Write fixity info
  if (print_fixity) {
    fixity <- fmi2_fixity(y, algorithm = "md5")
    capture.output(cat("### FIXITY CHECKSUM: \n\n"),
                   file = tempfile_for_sink, append = TRUE)
    capture.output(print(
      paste0("Fixity checksum (md5) for the dataset: ", fixity)),
      file = tempfile_for_sink, append = TRUE)
    capture.output(cat("\n"),
                   file = tempfile_for_sink, append = TRUE)
  }

  # Print citation and code, and return data
  if (print_code || print_citation || print_fixity) {
    cat(readLines(tempfile_for_sink), sep = "\n")
  }
  return(y)
}
