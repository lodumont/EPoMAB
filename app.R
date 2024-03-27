## Shiny Test App
## Interface to Filemaker database or exported csv
## Application file (app.R)

library(shiny)

# App
# source("ui.R")
# source("server.R")

devtools::load_all()

shinyApp(ui = ui, server = server)

#runApp(launch.browser = T)
