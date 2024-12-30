library(shiny)
library(rsconnect)

# Source the UI and server files
source("ui.R")
source("server.R")

# Run the Shiny app
shinyApp(ui = ui, server = server)

# Set account info for shinyapps.io
rsconnect::setAccountInfo(name='2thqkc-yongjae-lee',
                          token='130F1D93839B3DFBC02A69C07F4E4BE7',
                          secret='1t0SstNwGTuLILVby7ryL8t389ptSJYg95mo1G0x')

# Set working directory to the project folder
setwd("Home/Pathwat_PJT")

# Deploy the app to shinyapps.io with a custom title
rsconnect::deployApp(appTitle = "yongjae lee가 만든 앱")