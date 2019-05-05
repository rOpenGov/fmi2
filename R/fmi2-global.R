# Environment that holds various global variables and settings for fmi2,
# such as the URLs. It is not exported and should not be directly
# manipulated by other packages.
fmi2_global <- new.env(parent = emptyenv())

# URL that defines where the FMI saved queries and their descriptions can be
# found.
fmi2_global$saved_queries_url <- "http://opendata.fmi.fi/wfs?service=WFS&version=2.0.0&request=describeStoredQueries&"

# Following list keeps track on which fmi2 function wraps which stored query on
# the FMI API.
fmi2_global$function_map <- list(
  "fmi::observations::weather::daily::timevaluepair" = "daily_weather"
)
