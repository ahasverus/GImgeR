downloadGoogleImages <- function(keyword = NULL, n_photos = 200, path = ".", return = TRUE) {



#'  -------------------------------------------------------------------------   @EscapeCharacters


  keyword <- gsub("[[:space:]]+", " ", keyword)
  keyword <- gsub("^[[:space:]]|[[:space:]]$", "", keyword)
  keyword <- gsub("[[:space:]]", "+", keyword)



#'  -------------------------------------------------------------------------   @OutputDirectory


  path <- file.path(path, "pictures", keyword)
  dir.create(path, recursive = TRUE, showWarnings = FALSE)



#'  -------------------------------------------------------------------------   @GetPagesNumber

  items_per_page <- 20
  n_pages        <- ceiling(n_photos / items_per_page)
  page           <- 0



  tab <- data.frame(
    keyword   = character(0),
    photo_id  = character(0),
    weblink   = character(0)
  )


  n <- 0

  for (i in 1:n_pages) {



#'  -------------------------------------------------------------------------   @WriteURLQuery


    url <- paste0(
      "https://www.google.com/",
      "search",
      "?q=", keyword,
      "&source=lnms",
      "&tbm=isch",
      "&safe=images",
      # "&tbs=isz:l,ift:jpg",
      "&start=",
      (i * items_per_page) - items_per_page
    )



#'  -------------------------------------------------------------------------   @ScrapURLContent


    html <- tryCatch({
      readLines(
        con       = url,
        warn      = FALSE,
        encoding  = "utf8"
      )},
      error = function(e){}
    )



#'  -------------------------------------------------------------------------   @CleanHTMLContent


    html <- paste0(html, collapse = "")

    html <- gsub("\\s+", " ", html)
    html <- gsub(">", ">\n", html)
    html <- gsub("<", "\n<", html)

    burst <- strsplit(html, "\\n")[[1]]
    burst <- burst[which(
      unlist(
        lapply(
          burst,
          function(x) {
            ifelse(x == "", 1, 0)
          }
        )
      ) == 0
    )]

    burst <- gsub("^\\s|\\s$", "", burst)
    burst <- unlist(strsplit(burst, "\\n"))



#'  -------------------------------------------------------------------------   @GetThumbnailURL


    img_urls <- burst[grep("^<img ", burst)]
    img_urls <- strsplit(img_urls, "src=|\\\"")
    img_urls <- unlist(lapply(img_urls, function(x) x[grep("^http", x)]))



#'  -------------------------------------------------------------------------   @GetOriginalPictureURL


    link_urls <- burst[grep("^<a href=\\\"/url\\?q=", burst)]
    link_urls <- gsub("^<a href=\\\"/url\\?q=|\\\">", "", link_urls)
    link_urls <- strsplit(link_urls, "&amp;")
    link_urls <- unlist(lapply(link_urls, function(x) x[1]))



#'  -------------------------------------------------------------------------   @DownloadThumbnails



    for (k in 1:length(img_urls)) {


      photo_id <- format(Sys.time(), "%Y%m%d%H%M%S")

      download.file(
        url       = img_urls[k],
        destfile  = file.path(path, paste0(photo_id, ".jpg"))
      )

      Sys.sleep(1)

      dat <- data.frame(
        keyword   = keyword,
        photo_id  = photo_id,
        weblink   = link_urls[k]
      )

      tab <- rbind(tab, dat)
    }
  }

  write.table(
    x          = tab,
    file       = file.path(
      path, paste0("_", gsub("[[:punct:]]", "", keyword), ".txt")
    ),
    row.names  = FALSE,
    sep        = "\t"
  )

  if (return) { return(tab) }
}
