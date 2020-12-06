#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Philippines Gender Data"),

    
    mainPanel(
            align = "center",
            width = 12,
            selectInput("variable","Choose data to plot:",
                        list (
                            "Employers"="SL.EMP.MPYR",
                            "Employment in agriculture"="SL.AGR.EMPL",
                            "Employment in industry"="SL.IND.EMPL",
                            "Employment in services"="SL.SRV.EMPL",
                            "Employment to population ratio, ages 15+"="SL.EMP.TOTL.SP",
                            "Employment to population ratio, ages 15- 24"="SL.EMP.1524.SP"
                       )
                
            ),
            submitButton("Submit"),
            tags$a(),
            plotOutput("distPlot")
        
    )
))
