library (readr)
library(plotly)
library(plyr)
library(dplyr)
library(stringr)

myUrl <- "https://data.humdata.org/dataset/bfeb4908-1629-4ae1-ab35-d9010838a1bf/resource/c1ce368c-82d8-4b0d-a2dc-c67f085778f5/download/gender_phl.csv"
genderDF <- read_csv(url(myUrl))
genderDF <- genderDF [-1,]
colnames(genderDF)<- c("Country Name",
                       "Country.ISO3",
                       "Year",
                       "Indicator",
                       "Code",
                       "Value")

#Employment data subset 
df <- as.data.frame(genderDF[grep("^Employ",genderDF$Indicator),])

#Changing Indicators to Factor
df$Code <- as.factor(df$Code)
df$Year <- as.numeric(df$Year)
df$Value <- as.numeric(df$Value)

#Adding additional columns to merge sex data and categorize based on umbrella indicator 
df$Sex <- ifelse(grepl("FE",df$Code),"FEMALE","MALE")
df$ShortCode <- str_sub(df$Code,1,-7)
df$ShortCode <- as.factor(df$ShortCode)


for (i in 1:length(df$Indicator)){
  df$ShortName[i] <- strsplit(df$Indicator, "[,]")[[i]][1] %>% unlist()
  
}


df[df$ShortCode == "SL.EMP.TOTL.SP",]$ShortName <- "Employment to population ratio, ages 15+"
df[df$ShortCode == "SL.EMP.1524.SP",]$ShortName <- "Employment to population ratio, ages 15 - 24"

variable <- "SL.AGR.EMPL"
plotSub <- df[df$ShortCode == variable,]
titleText <-unique(df[df$ShortCode == variable,]$ShortName)
gPlot <- ggplot(as.data.frame(plotSub), aes(x = Year, y = Value, color = Sex))+
  geom_point() +
  labs(title = titleText)
ggplotly(gPlot)