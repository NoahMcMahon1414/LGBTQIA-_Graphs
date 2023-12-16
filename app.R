library(shiny)

# Source UI and Server Files to get UI and Server Variables
source("ui.R")
source("server.R")

# Run the application
shinyApp(ui = ui, server = server)
