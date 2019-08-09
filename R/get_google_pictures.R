#' @title Download pictures from Google Pictures
#'
#' @description
#' This function downloads pictures from Google Images website using Selenium
#' technology and the package \{code\link[RSelenium]{RSelenium}}.
#'
#' @param search_terms [string] A vector of terms to search pictures for.
#' @param n_photos [numeric] The number of pictures to download by search terms.
#' @param first_img [numeric] The position of the starting picture (default 1).
#' @param path [string] The directory to save pictures.
#' @param browser [string] The browser name ('chrome', 'firefox', 'phantomjs' or 'internet explorer')
#'
#' @author Nicolas Casajus, \email{nicolas.casajus@@gmail.com}
#'
#' @export
#'
#' @return This function does not return any object but downloads pictures on the hard drive
#'
#' @examples
#'
#' get_google_pictures(
#'   search_terms = "whale drone photo aerial",
#'   n_photos    = 1000,
#'   first_img   = 1,
#'   path        = "~/Desktop",
#'   browser     = "firefox"
#' )

get_google_pictures <- function(
  search_terms = NULL, n_photos = 50, first_img = 1, path = ".", browser = "firefox") {


#'  -------------------------------------------------------------------------   @LoadAddings


  require("RSelenium")

  opath <- path



#'  -------------------------------------------------------------------------   @EscapeCharacters


  search_terms <- unlist(
    lapply(
      search_terms,
      function(x) {
        x <- gsub("[[:space:]]+", " ", x)
        x <- gsub("^[[:space:]]|[[:space:]]$", "", x)
        x <- gsub("[[:space:]]", "+", x)
      }
    ),
    use.names = FALSE
  )



  for (search_term in search_terms) {



    cat(paste0("\n>>> Searching pictures for: \"", search_term, "\"\n\n"))


#'  -------------------------------------------------------------------------   @WriteURLQuery


    url <- paste0(
      "https://www.google.com/",
      "search",
      "?q=", search_term,
      "&source=lnms",
      "&tbm=isch",
      "&safe=images"
    )



#'  -------------------------------------------------------------------------   @OutputDirectory


    path <- file.path(opath, "pictures", gsub("[[:punct:]]", "_", search_term))
    dir.create(path, recursive = TRUE, showWarnings = FALSE)



#'  -------------------------------------------------------------------------   @RunSeleniumServer


    rs_driver <- rsDriver(
      port     = 4567L,
      browser  = browser,
      verbose  = FALSE
    )

    cat(paste0("  -[x] Opening ", browser, "\n"))



#'  -------------------------------------------------------------------------   @OpenURLInBrowser


    rs_client <- rs_driver$client

    rs_client$navigate(url)

    cat(paste0("  -[x] Browsing: \"", url, "\"\n"))



#'  -------------------------------------------------------------------------   @ScrollDown


    thumb_links <- rs_client$findElements(using = "class", value = "rg_l")
    new_links   <- TRUE

    while (length(thumb_links) < (n_photos + first_img - 1) && new_links) {

      scroll_down <- rs_client$findElement(using = "css", value = "body")
      scroll_down$sendKeysToElement(list(key = "end"))

      previous_links <- thumb_links

      Sys.sleep(0.75)

      thumb_links <- rs_client$findElements(using = "class", value = "rg_l")

      if (length(thumb_links) == length(previous_links)) {

        if (length(thumb_links) < (n_photos + first_img - 1)) {

          button <- rs_client$findElement(using = 'id', value = "smb")
          button$clickElement()

          previous_links <- thumb_links

          Sys.sleep(0.75)

          thumb_links <- rs_client$findElements(using = "class", value = "rg_l")

          if (length(thumb_links) == length(previous_links)) {

            new_links <- FALSE
          }

        } else {

          new_links <- FALSE

        }
      }
    }



#'  -------------------------------------------------------------------------   @GetThumbnailsURL


    thumb_links <- rs_client$findElements(using = "class", value = "rg_l")

    thumb_links <- unlist(
      sapply(
        thumb_links,
        function(x){
          x$getElementAttribute("href")
        }
      )
    )


    if (length(thumb_links) >= (n_photos + first_img - 1)) {

      thumb_links <- thumb_links[first_img:(n_photos + first_img - 1)]

    } else {

      thumb_links <- thumb_links[first_img:length(thumb_links)]
    }


    cat(paste("  -[x]", length(thumb_links), "on", n_photos, "images found\n"))

    photo_id <- as.numeric(format(Sys.time(), "%Y%m%d%H%M%S"))
    count    <- 0


    for (k in 1:length(thumb_links)) {



#'  -------------------------------------------------------------------------   @GoToOriginalImage


      cat(paste0("  -[ ] Trying to download picture #", k, "...\r"))

      rs_client$navigate(thumb_links[k])



#'  -------------------------------------------------------------------------   @GetImagesURL


      img_link <- rs_client$findElements(using = "class", value = "irc_mi")

      img_link <- unlist(
        sapply(
          img_link,
          function(x){
            x$getElementAttribute("src")
          }
        )
      )



#'  -------------------------------------------------------------------------   @DownloadImages


      attempt <- tryCatch({
        download.file(
          url       = img_link,
          destfile  = file.path(path, paste0("IMG", photo_id, ".jpg")),
          quiet     = TRUE
        )},
        error = function(e){}
      )

      if (!is.null(attempt)) {

        count    <- count + 1
        photo_id <- photo_id + 1
      }




#'  -------------------------------------------------------------------------   @GoBack


      Sys.sleep(0.75)
      rs_client$goBack()
    }

    cat(paste0("  -[x] Trying to download picture #", k, "...\r"))
    cat(paste0("\n  -[x] ", count, " on ", length(thumb_links)," pictures successfully downloaded\n"))
    cat(paste0("  -[x] Pictures saved in: ", path, "/\n"))



  #'  -------------------------------------------------------------------------   @CloseSeleniumServer


    rs_client$close()
    xxx <- rs_driver$server$stop()

    cat(paste0("  -[x] Closing ", browser, "\n\n"))
  }
}
