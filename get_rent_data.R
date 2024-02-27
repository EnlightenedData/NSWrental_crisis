get_rent_data <- function(){#year = 2023
page <- "https://www.facs.nsw.gov.au/resources/statistics/rent-and-sales/back-issues?result_536530_result_page=1&q=rent%20table&filtered=true"
a <- readLines(page)

#find lines of interest
loc.zip <- grep(paste0(".xlsx"), a)

#A convenience function that uses line from original page
#marker of file type to locate name and page (url original page)
#------------------------------------
# Example href file to download
#href=\"https://www.facs.nsw.gov.au/__data/assets/excel_doc/0016/834001/Rent-tables-March-2022-quarter.xlsx\"

convfn <- function(line, marker, page){
    i <- unlist(gregexpr(pattern ='href="', line)) + 6 #6 character from href=\ before url
    i2<- unlist(gregexpr(pattern = marker, line)) + 4  # 4 characters from example "xlsx"
    #target file
    .destfile <- substring(line, i[1], i2[1])
    #target url
    .name      <- .destfile #paste(page, .destfile, sep = "/")
    #print targets
    cat(.destfile, '\n')
    #the workhorse function
    download.file(.destfile, basename(.destfile))
}
#--------------------------------------------

#they will save in your working directory
#use setwd() to change if needed
print(getwd())
mainDir <- getwd()
subDir <- "RentData"
dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
setwd(file.path(mainDir, subDir))

#get the .zip files and download them
sapply(a[loc.zip], 
       FUN = convfn, 
       marker = '.xlsx\\\"', #this is key part, locates zip file name
       page = page)

# zip::zip(zipfile = paste0(getwd(), paste0("/",year, ".zip")), 
#          files = list.files(paste0(getwd(), paste0("/",year)), full.names = TRUE), 
#          mode = "cherry-pick")

cat("quaterly median weekly rent data have been download to the working directory for parsing")
}