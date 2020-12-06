#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(ggplot2)
library(plyr)
library(dplyr)
library(stringr)
library(shiny)

myUrl <- "https://data.humdata.org/dataset/bfeb4908-1629-4ae1-ab35-d9010838a1bf/resource/c1ce368c-82d8-4b0d-a2dc-c67f085778f5/download/gender_phl.csv"
genderDF <- read.csv(myUrl)

#Remove column description in first row
genderDF <- genderDF [-1,]

#Renaming columns to make it usable
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

#Adding short name to be used for text title
for (i in 1:length(df$Indicator)){
    df$ShortName[i] <- strsplit(df$Indicator, "[,]")[[i]][1] %>% unlist()
    
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    inputCode <- reactive({
        input$variable
    })
    
    output$distPlot <- renderPlot({
        titleText <- unique(df[df$ShortCode == inputCode(),]$ShortName)
        plotSub <- df[df$ShortCode == inputCode(),]
        gPlot <- ggplot(as.data.frame(plotSub), aes(x = Year, y = Value, color = Sex))+
            geom_point() +
            labs(title = titleText)
        gPlot
    })
    

})
