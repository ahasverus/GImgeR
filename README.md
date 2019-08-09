GImgeR - Download Google Pictures Using RSelenium
=========================================================


Overview
--------

This R function downloads pictures from Google Pictures website using the Selenium technology and the R package `RSelenium`.



Requirements
--------

This function is based on the R package `RSelenium`. First, you have to install this package and its dependencies:

```r
install.packages("RSelenium")
```

The *Selenium* technology remotely takes the control of a web browser among: [*Google Chrome*](https://www.google.com/chrome/), [*Mozilla Firefox*](https://www.mozilla.org/firefox/), *Internet Explorer*, or [*PhantomJS*](https://phantomjs.org/). Be sure to have one of them installed.



Usage
--------

```r

#' ---------------------------------------------------------------------------- DefinePaths

repos_path    <- "path_to_git_repos"
pictures_path <- "path_to_folder_to_store_pictures"


#' ---------------------------------------------------------------------------- LoadCodeSource

source(file.path(repos_path, "R", "get_google_pictures.R"))


#' ---------------------------------------------------------------------------- SingleTerm

get_google_pictures(
  search_terms = "whale",
  n_photos     = 20,
  first_img    = 1,
  path         = pictures_path,
  browser      = "firefox"
)


#' ---------------------------------------------------------------------------- MulipleTerms

get_google_pictures(
  search_terms = paste(c("whale", "shark"), "drone photo aerial"),
  n_photos     = 20,
  first_img    = 1,
  path         = pictures_path,
  browser      = "firefox"
)

```



To go further
--------

This code is based on the `RSelenium` package. Here is some useful links:

- [Package help](https://cran.r-project.org/web/packages/RSelenium/RSelenium.pdf)
- [Package basics](https://cran.r-project.org/web/packages/RSelenium/vignettes/basics.html)
