## Shiny Test App
## Interface to Filemaker database or exported csv
## User Interface (ui.R)

library(shinytitle)
library(shinyWidgets)

source("R/_utils.R", local = TRUE)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
                    .nav-tabs>li>a {color: #29804e;}
                   ")
      )#,
    # tags$script(
    #   HTML(
    #     "
    #     Shiny.addCustomMessageHandler(
    #      'removeleaflet',
    #       function(x){
    #         console.log('deleting',x)
    #         // get leaflet map
    #         var map = HTMLWidgets.find('#' + x.elid).getMap();
    #         // remove
    #         map.removeLayer(map._layers[x.layerid])
    #       }
    #     )
    #     "
    #   )
    # )
  ),
  
  # Page title in the browser
  title = "Base EPoMAB",
  use_shiny_title(),
  
  ## Title row
  titlePanel(
    fluidRow(
      column(10, align = "left",
             div(span("Base", style = "color:#29804e; font-weight: normal"),
                 span("Épées à poignée métallique de l'âge du Bronze", style = "color:#29804e; font-style: italic"),
                 span("(EPoMAB)", style = "color:#29804e; font-weight: normal")
                 )
             ),
      column(2, align = "right",
             radioGroupButtons(inputId = "lang",
                                  label = NULL,
                                  choices = c("Fr","En"),
                                  selected = "Fr"))
    )
  ),

    tabsetPanel(id = "mainpanel",
      tabPanel(title = "Présentation", value = "tabpres",
               fluidRow(
                 br(),
                 column(1,
                        span()
                 ), # end spacing column
                 column(3, align = "center",
                        img(src='Buggenum_poignee_web.png', 
                            width = "75%", height = "75%"),
                        p("Épée de Buggenum (Pays-Bas). © L. Dumont.")
                       ), # end column picture
                 column(1,
                        span()
                       ), # end spacing column
                 column(4,
                       includeMarkdown("www/intro.md"),
                       p(),
                       img(src='Tournus_Farges_motif_lame.png', 
                           width = "75%", height = "75%"),
                       ), # end text column
                 column(1,
                        span()
                 ), # end spacing column
               ) # end fluidRow
              ), # end tabPanel Présentation
      tabPanel(title = "Données", value = "tabletab",
          sidebarLayout(
            sidebarPanel(width=2,
              
              # Typologie
              p(span("Typologie", style = "font-weight: bold; font-size:16px;")),
              selectInputS("swordGrp", "Groupe :"),
              selectInputS("swordType", "Type :"),
              selectInputS("swordVar", "Variante :"),
          
              # Contexte
              div(selectInput("swordCont", label=span("Contexte", style = "font-size: 16px;"),
                              choices = NULL, selected = NULL, multiple = TRUE)),
              
              # Chronologie
              p(span("Chronologie", style = "font-weight: bold; font-size:16px;")),
              selectInputS("swordPer", "Période :"),
              selectInputS("swordPha", "Phase :"),
              selectInputS("swordStep", "Étape :"),
              
              # Géographie
              p(span("Géographie", style = "font-weight: bold; font-size:16px;")),
              selectInputS("swordCountry", "Pays :"),
              selectInputS("swordReg", "Région :")
              
            ), # end sidebarPanel
            mainPanel(width=8,
              div(style="display:inline-block",
                  radioButtons("search_typo","Mode de recherche :", 
                               choices = c("ET","OU"), selected = "ET", inline = T)),
              div(style="display:inline-block", actionButton("reset", "Reset")),
              #div(style="display:inline-block", actionButton("tomap","Aller à la carte")),
              div(style="display:inline-block", downloadButton("download.table","Télécharger")),
              p(),
              fluidRow(DT::dataTableOutput("table"))
            ) # end mainPanel
          ) # end sidebarLayout
      ), #end tabPanel Données
    tabPanel(title = "Carte", value = "maptab",
             fluidRow(
               column(4,
                 align = "left",
                 HTML("<h4>Cliquez sur un point pour visualiser les informations</h4>")
               ),
               # column(2,
               #        radioButtons("map_mode","Mode choisi", choices = c("Sélection","Export"), selected = "Sélection", inline = T)
               # ),
               column(2,
                      actionButton("map.select.all","Tout sélectionner")
               ),
               column(1,
                      actionButton("reset.map.selection", "Reset")
               ),
               column(2,
                 uiOutput("button.table.map")
               )
             ),
             fluidRow(
              column(9,
                     leafletOutput("swordmap", height = "590px")
                     ),
              column(3,
                     uiOutput("riverbuffer")
                     )
             ),
             fluidRow(uiOutput("clickedpoint"))
      ),
    tabPanel("Bibliographie", value = "tabbib",
            p(),
            p("Les données présentes dans cette base sont issues du dépouillement des références ci-dessous."),
            p("La liste des références utilisées est également disponible au format bibtex : ",
              a(href="EPoMAB.bib", "Télécharger la bibliographie", download=NA, target="_blank")),
            p(),
            #tags$iframe(src="EPoMAB_biblio.html", width = 800, height = 700)
            includeHTML("www/EPoMAB.css"),
            includeHTML("www/EPoMAB_biblio.html")
            ),
    tabPanel("Documentation", value = "tabdoc",
             includeMarkdown("README.md")
             ),
    tabPanel("Contact", value = "tabcontact",
             includeMarkdown("www/contact.md"),
             img(src="Huma-Num.png", width = "30%", height = "30%")
            )
  ) # end TabsetPanel
)