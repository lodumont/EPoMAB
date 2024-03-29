## Small functions

selectInputS <- function(id, mylabel) {
  div(selectInput(id, label=span(mylabel, style = "font-weight: normal"), 
                  choices = NULL, selected = NULL, multiple = TRUE))
}