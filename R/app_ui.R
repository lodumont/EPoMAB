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
      ),
    tags$script( # Deleting drawn polygons on map when hitting reset button
      HTML(
        "
        Shiny.addCustomMessageHandler(
         'removeleaflet',
          function(x){
            console.log('deleting',x)
            // get leaflet map
            var map = HTMLWidgets.find('#' + x.elid).getMap();
            // remove
            map.removeLayer(map._layers[x.layerid])
          }
        )
        "
      )
    )
  ),
  
  # Page title in the browser
  title = "Base EPoMAB",
  use_shiny_title(),
  
  ## Title row
  titlePanel(
    fluidRow(
      column(10, align = "left",
             uiOutput("maintitle"),
             tags$head(tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "icon.png"))
             ),
      column(2, align = "right",
             radioGroupButtons(inputId = "lang",
                                  label = NULL,
                                  choices = c("Fr","En"),
                                  selected = "Fr"))
    )
  ),

    tabsetPanel(id = "mainpanel",
      tabPanel(title = uiOutput("tabpres"), value = "tabpres",
               fluidRow(
                 br(),
                 column(1,
                        span()
                 ), # end spacing column
                 column(3, align = "center",
                        img(src='Buggenum_poignee_web.png', 
                            width = "70%", height = "70%"),
                        uiOutput("legend")
                        # div(p("Épée de Buggenum (Pays-Bas). © L. Dumont."),
                        #     style = "font-size: small;")
                       ), # end column picture
                 column(1,
                        span()
                       ), # end spacing column
                 column(4,
                       #includeMarkdown("www/intro.md"),
                       uiOutput("welcome"),
                       p(),
                       div(img(src='Tournus_Farges_motif_lame.png', 
                           width = "65%", height = "65%"),
                           style = "text-align: center;"
                       )), # end text column
                 column(1,
                        span()
                 ), # end spacing column
               ) # end fluidRow
              ), # end tabPanel Présentation
      tabPanel(title = uiOutput("tabtable"), value = "tabtable",
          sidebarLayout(
            sidebarPanel(width=2,
              
              # Typologie
              #p(span("Typologie", style = "font-weight: bold; font-size:16px;")),
              uiOutput("filter.typo"),
              selectInputS("swordGrp", "Groupe :"),
              selectInputS("swordType", "Type :"),
              selectInputS("swordVar", "Variante :"),
          
              # Contexte
              div(selectInput("swordCont", label=uiOutput("filter.context"),
                              choices = NULL, selected = NULL, multiple = TRUE)),
              
              # Chronologie
              #p(span("Chronologie", style = "font-weight: bold; font-size:16px;")),
              uiOutput("filter.chrono"),
              selectInputS("swordPer", "Période :"),
              selectInputS("swordPha", "Phase :"),
              selectInputS("swordStep", "Étape :"),
              
              # Géographie
              #p(span("Géographie", style = "font-weight: bold; font-size:16px;")),
              uiOutput("filter.geo"),
              selectInputS("swordCountry", "Pays :"),
              selectInputS("swordReg", "Région :")
              
            ), # end sidebarPanel
            mainPanel(width=8,
              div(style="display:inline-block",
                  uiOutput("search.mode")
                  # radioButtons("search_typo","Mode de recherche :",
                  #              choices = c("ET","OU"), selected = "ET", inline = T)
                  ),
              div(style="display:inline-block", actionButton("reset", "Reset")),
              #div(style="display:inline-block", actionButton("tomap","Aller à la carte")),
              div(style="display:inline-block", downloadButton("download.table", textOutput("download",
                                                                                            inline = T))),
              p(),
              fluidRow(DT::dataTableOutput("table"))
            ) # end mainPanel
          ) # end sidebarLayout
      ), #end tabPanel Données
    tabPanel(title = uiOutput("tabmap"), value = "tabmap",
             fluidRow(
               column(4,
                 align = "left",
                 uiOutput("map.select.text")
               ),
               # column(2,
               #        radioButtons("map_mode","Mode choisi", choices = c("Sélection","Export"), selected = "Sélection", inline = T)
               # ),
               column(2,
                      actionButton("map.select.all", textOutput("select.all"))
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
    tabPanel(title = uiOutput("tabbib"), value = "tabbib",
            uiOutput("biblio"),
            # p(),
            # p("Les données présentes dans cette base sont issues du dépouillement des références ci-dessous."),
            # p("La liste des références utilisées est également disponible au format bibtex : ",
            #   a(href="EPoMAB.bib", "Télécharger la bibliographie", download=NA, target="_blank")),
            # p(),
            #tags$iframe(src="EPoMAB_biblio.html", width = 800, height = 700)
            includeHTML("www/EPoMAB.css"),
            includeHTML("www/EPoMAB_biblio.html")
            ),
    tabPanel("Documentation", value = "tabdoc",
             #includeMarkdown("README.md")
             uiOutput("readme")
             ),
    tabPanel("Contact", value = "tabcontact",
             #includeMarkdown("www/contact.md"),
             uiOutput("contact"),
             img(src="Huma-Num.png", width = "30%", height = "30%")
            )
  ) # end TabsetPanel
)