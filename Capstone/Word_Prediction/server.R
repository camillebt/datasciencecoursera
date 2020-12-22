#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("Pred.R")

shinyServer(function(input, output) {
  
  # original sentence
  output$userSentence <- renderText({input$userInput});
  
  # reactive controls
  observe({
      output$prediction1 <- reactive({predictProc(input$userInput)[1]})
      output$prediction2 <- reactive({predictProc(input$userInput)[2]})
      output$prediction3 <- reactive({predictProc(input$userInput)[3]})
  })
  
})