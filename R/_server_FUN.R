## functions for server side

# Equivalence table for UI id and data column
table_eq <- tibble::tribble(
  ~ id,         ~ col,
  "swordGrp",   "Groupe",
  "swordType",  "Type",
  "swordVar",  "Variante",
  "swordCont",  "Contexte",
  "swordPer",   "Periode",
  "swordPha",    "Phase",
  "swordStep",   "Etape",
  "swordCountry", "Pays",
  "swordReg",    "Region"
)

updateSelectInput_col <- function(id, col) {
  updateSelectInput(session, id,
                    choices = sort(unique(EPoMAB[,col])))
}

updateSelectInput_smode_ET <- function(id, col, col2) {
  id2 <- table_eq$id[which(table_eq$col == col2)]
  updateSelectInput(session, id,
                    choices = sort(unique(EPoMAB[,col][which(EPoMAB[,col2] %in% input[[id2]])])))
}

updateSelectInput_reset <- function(id, col) {
  updateSelectInput(session, id, choices = sort(unique(EPoMAB[,col])), selected = character(0))
}

includeLangMarkdown <- function(file.fr, file.en) {
  renderUI({
    file <- switch(input$lang,
                   "Fr" = file.fr,
                   "En" = file.en,
                   stop("Option inconnue")
    )
    includeMarkdown(file)
  })
}

# Equivalence table between tab titles and id
tabtitles <- tibble::tribble(
  ~ id,          ~ fr,          ~en,    
  "tabpres", "Présentation", "Introduction",
  "tabtable",   "Données",      "Data",
  "tabmap",      "Carte",        "Map",
  "tabbib",   "Bibliographie", "References"
)

# Function to switch languages of tab titles
switchLang <- function(id, fr, en) {
  output[[id]] <- renderText({
    switch(input$lang,
           "Fr" = fr,
           "En" = en,
           stop("Option inconnue")
    )
  })
}
