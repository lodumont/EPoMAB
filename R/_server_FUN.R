## functions for server side

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
