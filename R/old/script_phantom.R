
library(plyr)
library(reshape2)
require(rvest)


scrapeJSSite <- function(searchTerm){
  

  url <- paste0("https://www.google.de/search?q=",searchTerm, "&source=lnms&tbm=isch&sa=X")
  
  lines <- readLines("imageScrape.js")
  lines[1] <- paste0("var url ='", url ,"';")
  writeLines(lines, "imageScrape.js")
  
  ## Download website
  system("phantomjs imageScrape.js")
  
  pg <- read_html("1.html")
  files <- pg %>% html_nodes("img") %>% html_attr("src")
  df <- data.frame(images=files, search=searchTerm)
  return(df)
}


downloadImages <- function(files, searchTerm, outPath){
  for(i in 1:length(files)){
    download.file(files[i], destfile = paste0(outPath, "/", searchTerm, "_", i, ".jpg"), mode = 'wb')
  }
  
}

### exchange the search terms here!
gg <- scrapeJSSite(searchTerm = "dolphin")
downloadImages(as.character(gg$images), searchTerm="dolphin",outPath="images")

