# Download pictures from Google Pictures

#' ---------------------------------------------------------------------------- @LoadCodeSource

library(RSelenium) # Require Firefox
source(file.path("R", "get_google_pictures.R"))


#' ---------------------------------------------------------------------------- @GoogleSearchEN

get_google_pictures(
  search_terms  = paste(
    c(
      "shark",
      "sea turtle",
      "dugong"
    ),
    "drone photo"
  ),
  n_photos      = 2000,
  first_img     = 1,
  path          = ".",
  browser       = "firefox"
)
