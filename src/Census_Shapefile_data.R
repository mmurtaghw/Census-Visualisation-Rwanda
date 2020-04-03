library(leaflet)
library(rgdal) 
library(dplyr)
library(foreign)
library(leaflet)
library(here)

###################################################

#PART 1: SETUP

###################################################

#Set the Directory where the shapefiles and census data are

setwd(paste0(here() , "/data"))

#Read in the census microdata

CensusData <- read.dta("FormattedCensusMicrodata.dta", convert.factors = TRUE)

#Read in the sector data and extract the table of data associated with the shapefile

districts <- readOGR("Sector.shp",
                     layer = "Sector")
shapeData <- districts@data

#Merge the census data with the spatial data
#Extract just those observations with over 60

Spatial_Census <- merge.data.frame(shapeData,CensusData, by.x = "Sect_ID", by.y = "SectCode")

Spatial_Census <-  Spatial_Census %>%
  
  count(Sect_ID) %>%
  inner_join(Spatial_Census, by = "Sect_ID", copy = FALSE, suffix = c(".x", ".y"))

names(Spatial_Census)[2] <- "Sample_Pop_Sector"

###################################################

#PART 2: CREATING AN OVER 60S MAP

###################################################


#Extract just those observations with over 60

data = filter(Spatial_Census, P05 >= 60)


#Select just the variables of interest, count the over 60s in each sector

data <-  data %>%
            count(Sect_ID) %>%
               inner_join(data, by = "Sect_ID", copy = FALSE, suffix = c(".x", ".y"))  %>%
                  select(Sect_ID, n, Prov_ID, Province, Dist_ID, District, Name, Sample_Pop_Sector) 

#Rename the deault count data as population over 60 and reduce to unique values to give us a
#table of sector data

names(data)[2] <- "Pop_Over_60"
output <- data %>% unique()

#Create a variable with proportion of sample that are over 60

output <- mutate(output, Percent_Over_60 = (Pop_Over_60 / Sample_Pop_Sector) * 100)

#return the data to the geospatial shapefile data and transform the shapefile data
#to a projection that leaflet can take


districts@data <- output
districts <- spTransform(districts, CRS("+proj=longlat +datum=WGS84"))

#Create bins of data values for creating the heatmap
#Setting the chloropleth to a range of yellow or red based on how many in the sector are over 60

bins <- c(0, 1, 2, 3, 4, 5, 6,7, 8, Inf)
pal <- colorBin("YlOrRd", domain = districts@data$Percent_Over_60, bins = bins)

#Creating labels for the tooltip indicating the exact number of over 60s when the cursor
#hovers over that particular sector

labels <- sprintf(
  "<strong>%s</strong><br/>%g percent of people over 60",
  districts@data$Name, districts@data$Percent_Over_60
) %>% lapply(htmltools::HTML)

#Render the leaflet

leaflet(districts) %>%
  addPolygons(color = "white", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~pal(Percent_Over_60),
              highlightOptions = highlightOptions(color = "black", weight = 2,
                                                  bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(
              style = list("font-weight" = "normal", padding = "3px 8px"),
              textsize = "15px",
              direction = "auto"))

###################################################

#PART 2: ACCESS TO WATER

###################################################


data = filter(Spatial_Census, H10 <= 3)

data <-  data %>%
  
  count(Sect_ID) %>%
  inner_join(data, by = "Sect_ID", copy = FALSE, suffix = c(".x", ".y"))  %>%
  select(Sect_ID, n, Prov_ID, Province, Dist_ID, District, Name, Sample_Pop_Sector) 

names(data)[2] <- "Access_to_running_water"
output <- data %>% unique()

output <- mutate(output, Percent_Access = (Access_to_running_water / Sample_Pop_Sector) * 100)

districts@data <- output
#districts <- spTransform(districts, CRS("+proj=longlat +datum=WGS84"))


#Create bins of data values for creating the heatmap
#Setting the chloropleth to a range of yellow or red based on how many in the sector are over 60

bins <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, Inf)
pal <- colorBin("BuGn", domain = districts@data$Percent_Access, bins = bins)

#Creating labels for the tooltip indicating the exact number of over 60s when the cursor
#hovers over that particular sector

labels <- sprintf(
  "<strong>%s</strong><br/>%g percent with access to running water",
  districts@data$Name, districts@data$Percent_Access
) %>% lapply(htmltools::HTML)


#Render the leaflet

leaflet(districts) %>%
  addPolygons(color = "white", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~pal(Percent_Access),
              highlightOptions = highlightOptions(color = "black", weight = 2,
                                                  bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto"))

