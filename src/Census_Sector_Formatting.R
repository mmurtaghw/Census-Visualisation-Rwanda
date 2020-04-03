library(foreign)

#In this script we need to take the individual codes from the provinces, districts and sectors
#to build the unique 4 digit sector codes

#Set our working diretory as wherever the script is

setwd(paste0(here() , "/data"))
      
#Reads in the data from the census

data <- read.dta("rphc-2012-data-v2.dta", convert.factors = TRUE)

#Foreign reads in provinces as their labels for some reason
#so here we change the names of Provinces into their province codes

data$L01 = ifelse(data$L01 == "Kigali City", 1, data$L01)
data$L01 = ifelse(data$L01 == "Southern Province", 2, data$L01)
data$L01 = ifelse(data$L01 == "Western Province", 3, data$L01)
data$L01 = ifelse(data$L01 == "Northern Province", 4, data$L01)
data$L01 = ifelse(data$L01 == "Eastern Province", 5, data$L01)

#Here we need to put a zero before the sector codes that are single digits
#Then parse it back to an int

data$L03 = ifelse(data$L03 < 10, paste0( 0,data$L03), data$L03)
data$SectCode = paste0(paste0(data$L01,data$L02),data$L03)
data$SectCode = strtoi(data$SectCode)

#Write the finished file with the complete 4-digit sector code, ready to be merged with the shapefile

write.dta(data, file = "FormattedCensusMicrodata.dta")
