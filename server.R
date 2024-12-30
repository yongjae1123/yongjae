library(shiny)
library(plotly)

# Define server logic
server <- function(input, output, session) {
  # Initialize with random data
  set.seed(123)
  initial_data <- data.frame(
    Name = sample(c("John", "Jane", "Doe", "Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Hank", "Ivy", "Jack", "Kathy", "Leo", "Mona", "Nina", "Oscar", "Paul", "Quinn", "Rita", "Sam", "Tina", "Uma", "Vince"), 25, replace = TRUE),
    Height = sample(150:200, 25, replace = TRUE),
    Gender = sample(c("Male", "Female", "Other"), 25, replace = TRUE),
    Age = sample(18:60, 25, replace = TRUE),
    Time = Sys.time() - runif(25, min = 0, max = 10000),
    stringsAsFactors = FALSE
  )
  
  data <- reactiveVal(initial_data)
  
  observeEvent(input$saveButton, {
    newData <- data.frame(Name = input$name, Height = input$height, Gender = input$gender, Age = input$age, Time = Sys.time(), stringsAsFactors = FALSE)
    updatedData <- rbind(data(), newData)
    data(updatedData)
  })
  
  observeEvent(input$deleteButton, {
    row_to_delete <- as.numeric(strsplit(input$deleteButton, "_")[[1]][2])
    updatedData <- data()[-row_to_delete, ]
    data(updatedData)
  })
  
  output$dataTable <- renderTable({
    data_with_delete <- data()
    data_with_delete$Time <- format(data_with_delete$Time, "%Y-%m-%d %H:%M:%S")
    data_with_delete$Delete <- sapply(1:nrow(data_with_delete), function(i) {
      as.character(actionButton(paste0("deleteButton_", i), "X", class = "btn btn-danger btn-sm"))
    })
    data_with_delete
  }, sanitize.text.function = function(x) x, style = "font-size: 12px;")
  
  output$scatterPlot <- renderPlotly({
    plotData <- data()
    
    if (nrow(plotData) == 0) {
      plot_ly() %>%
        layout(title = "Height vs Age by Gender",
               xaxis = list(title = "Age", range = c(0, 100)),
               yaxis = list(title = "Height (cm)", range = c(0, 250)),
               annotations = list(
                 x = 50, y = 125, text = "No data available", showarrow = FALSE, font = list(color = "red")
               ))
    } else {
      colors <- ifelse(plotData$Gender == "Male", "blue", ifelse(plotData$Gender == "Female", "red", "green"))
      p <- plot_ly(plotData, x = ~Age, y = ~Height, type = 'scatter', mode = 'markers',
                   marker = list(color = colors),
                   text = ~paste("Name:", Name, "<br>Height:", Height, "cm<br>Gender:", Gender, "<br>Age:", Age, "<br>Time:", format(Time, "%Y-%m-%d %H:%M:%S")),
                   hoverinfo = 'text') %>%
        layout(title = "Height vs Age by Gender",
               xaxis = list(title = "Age", gridcolor = 'lightgray'),
               yaxis = list(title = "Height (cm)", gridcolor = 'lightgray'))
      
      if (input$addTrendline) {
        p <- p %>%
          add_trace(x = ~Age, y = ~fitted(lm(Height ~ Age, data = plotData)), type = 'scatter', mode = 'lines', line = list(color = 'black'), name = 'Trendline')
      }
      
      p
    }
  })
}