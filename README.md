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
#' -------------------------------------------------- @LoadCodeSource

source("path_to_git_repos/R/get_google_images.R")


#' -------------------------------------------------- @ExecuteCodeSource

get_google_pictures(
  search_term  = "whale drone photo aerial",
  n_photos     = 1000,
  first_img    = 1,
  path         = "path_to_folder_to_store_pictures",
  browser      = "firefox"
)

```



To go further
--------

This code is based on the `RSelenium` package. Here is some useful links:

- [Package help](https://cran.r-project.org/web/packages/RSelenium/RSelenium.pdf)
- [Package basics](https://cran.r-project.org/web/packages/RSelenium/vignettes/basics.html)