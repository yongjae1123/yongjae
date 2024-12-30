library(shiny)
library(plotly)

# Define UI
ui <- fluidPage(
  titlePanel("Data Entry App_Made by YongJae_20241231"),
  sidebarLayout(
    sidebarPanel(
      textInput("name", "Enter your name:", ""),
      numericInput("height", "Enter your height (cm):", value = NA, min = 0),
      radioButtons("gender", "Select your gender:",
                   choices = list("Male" = "Male", "Female" = "Female", "Other" = "Other")),
      sliderInput("age", "Select your age:", min = 1, max = 100, value = 25),
      actionButton("saveButton", "Save"),
      checkboxInput("addTrendline", "Add Trendline", FALSE)
    ),
    mainPanel(
      plotlyOutput("scatterPlot"),
      tableOutput("dataTable")
      
    )
  )
)
