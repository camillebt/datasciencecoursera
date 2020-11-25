# Leaflet Map 

library(leaflet)
my_map <- leaflet() %>%
  addTiles() %>%
  addMarkers()
my_map


#Adding markers
#Data taken from https://data.humdata.org/dataset/philippines-other-0-0-0-0-0-0-0-0


library(foreign)
yolandaPath <- read.dbf("Typhoon_Yolanda_Path.dbf", as.is = FALSE)
my_map <- cbind(yolandaPath$LAT,yolandaPath$LONG)
colnames(my_map)<- c("lat","lng")
myCategory <- yolandaPath$CATEGORY
levels(myCategory) <- c("3","4","5","6","7","1","2","3")
myCategory <- as.numeric(myCategory)
myCategory <- as.data.frame(myCategory)
colnames(myCategory) <- "cat"
myCategory$col <- as.factor(myCategory$cat)
levels(myCategory$col) <- brewer.pal(7,"YlOrRd")


#Creating Map with Markers
library(leaflet)
library(RColorBrewer)
my_map %>%
  leaflet() %>%
  addTiles() %>%
  addCircles(weight = 1, radius = myCategory$cat*50000,
             color = myCategory$col)