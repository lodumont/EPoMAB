## Shiny Test App
## Interface to Filemaker database or exported csv
## Server processing (server.R)
## TODO:
## - Correct crash if selection rectangle = line
## - color point according to user paramaters
## - Export map with north arrow + scale
## - Need two modes for map : selection and export, the latter with legends, north arrow and scale

library(DT)
#library(ggplot2)
library(dplyr)
library(data.table)
library(leaflet)
library(leaflet.extras)
#library(leafgl)
library(sf)
library(purrr)

server <- function(input, output, session) {
  source("R/_server_FUN.R", local = TRUE)
  # Data
  #mob <- read.csv("./data/mobilier.csv")
  #smob <- EPoMAB
  # smob <- data.frame(ID = mob$ID_Objet,
  #                    Pays = mob$Pays,
  #                    Region = mob$Region,
  #                    Commune = mob$Commune,
  #                    Site = mob$Nom_du_site,
  #                    Contexte = mob$Contexte.x,
  #                    Famille = mob$Groupe,
  #                    Type = mob$Type,
  #                    Variante = mob$Variante,
  #                    Periode = mob$Periode_obj,
  #                    Phase = mob$Phase_obj,
  #                    Etape = mob$Etape_obj,
  #                    Localisation = mob$Lieu_de_conservation,
  #                    Inventaire = mob$Inventaire,
  #                    X = mob$X,
  #                    Y = mob$Y)
  
  ## Render main title
  # output$maintitle <- renderUI({
  #   switch(input$lang,
  #          "Fr" = maintitle_fr,
  #          "En" = maintitle_en,
  #          stop("Option inconnue")
  #   )
  # })
  
  output$maintitle <- switchLangUI(maintitle_fr, maintitle_en)
  
  ## Welcome text rendering according to chosen language (French (default) or English)
  output$welcome <- includeLangMarkdown("www/intro_fr.md",
                                        "www/intro_en.md")
  
  output$legend <- switchLangUI(div(p("Épée de Buggenum (Pays-Bas). © L. Dumont."),
                                       style = "font-size: small;"),
                              div(p("Sword from Buggenum (the Netherlands). © L. Dumont."),
                                       style = "font-size: small;"))
  
  ## Welcome text rendering according to chosen language (French (default) or English)
  output$readme <- includeLangMarkdown("README.md",
                                        "README.en.md")
  
  ## Tab titles according to selected language: Fr (default) or En
  set_tabset_titles <- purrr::pmap(tabtitles, switchLangOutput)
  
  output$biblio <- switchLangUI(div(p(),
                                    p("Les données présentes dans cette base sont issues du dépouillement des références ci-dessous."),
                                    p("La liste des références utilisées est également disponible au format bibtex : ",
                                    a(href="EPoMAB.bib", "Télécharger la bibliographie", download=NA, target="_blank")),
                                    p()),
                                div(p(),
                                    p("Data were collected from the references listed below."),
                                    p("The list of references is also available in the bibtex format: ",
                                      a(href="EPoMAB.bib", "Download references", download=NA, target="_blank")),
                                    p()))
  
  ## Contact text rendering according to selected language
  output$contact <- includeLangMarkdown("www/contact.md",
                                        "www/contact_en.md")
  
  ## Table filter titles
  output$filter.typo <- switchLangUI(p(span("Typologie", style = "font-weight: bold; font-size:16px;")),
                                     p(span("Typology", style = "font-weight: bold; font-size:16px;")))
  output$filter.context <- switchLangUI(p(span("Contexte", style = "font-weight: bold; font-size:16px;")),
                                        p(span("Context", style = "font-weight: bold; font-size:16px;")))
  output$filter.chrono <- switchLangUI(p(span("Chronologie", style = "font-weight: bold; font-size:16px;")),
                                       p(span("Chronology", style = "font-weight: bold; font-size:16px;")))
  output$filter.geo <- switchLangUI(p(span("Géographie", style = "font-weight: bold; font-size:16px;")),
                                    p(span("Geography", style = "font-weight: bold; font-size:16px;")))
  
  ## Download button
  output$download <- switchLang("Télécharger","Download")
  output$download.map <- switchLang("Télécharger","Download")
  
  ## Select all map button
  output$select.all <- switchLang("Tout sélectionner", "Select all")
  
  ## Title above map
  output$map.select.text <- switchLangUI(HTML("<h4>Cliquez sur un point pour visualiser les informations</h4>"),
                                         HTML("<h4>Click on a point to see the data</h4>"))
  
  ## Selection button from selected river
  output$map.selection <- switchLang("Sélectionner", "Select")
  
  ## Table search mode
  output$search.mode <- renderUI({
    options <- switch(input$lang,
                      "Fr" = c("ET","OU"),
                      "En" = c("AND","OR"),
                      stop("Option inconnue")
    )
    label <- switch(input$lang,
                    "Fr" = "Mode de recherche",
                    "En" = "Search mode",
                    stop("Option inconnue")
    )
    radioButtons("search_typo", label,
                 choices = options, inline = T)
  })
  ## Table query parameters
  # Run customized function updateSelectInput_col through table_eq values
  usi_query <- purrr::pmap(table_eq, updateSelectInput_col)
  #updateSelectInput(session, "swordGrp", choices = sort(unique(EPoMAB$Groupe)))
  # updateSelectInput_col("swordGrp", "Groupe")
  # updateSelectInput(session, "swordType", choices = sort(unique(EPoMAB$Type)))
  # updateSelectInput(session, "swordVar", choices = sort(unique(EPoMAB$Variante)))
  # 
  # ## Selecting context
  # updateSelectInput(session, "swordCont", choices = sort(unique(EPoMAB$Contexte)))
  # 
  # ## Selecting chronology
  # updateSelectInput(session, "swordPer", choices = sort(unique(EPoMAB$Periode)))
  # updateSelectInput(session, "swordPha", choices = sort(unique(EPoMAB$Phase)))
  # updateSelectInput(session, "swordStep", choices = sort(unique(EPoMAB$Etape)))
  # 
  # ## Selecting geograpy
  # updateSelectInput(session, "swordCountry", choices = sort(unique(EPoMAB$Pays)))
  # updateSelectInput(session, "swordReg", choices = sort(unique(EPoMAB$Region)))
  
  ##Search mode
  #smode <- reactive(input$search_typo)
  
  ## Responsive type/variant selection for AND research
  observeEvent(input$swordGrp, {
    if(!is.null(input$swordGrp)) {
      if(input$search_typo == "ET" | input$search_typo == "AND"){
        # Updating choices according to what Groupe is selected
        usi_smode_ET_Groupe <- purrr::pmap(table_eq[2:7,], ~updateSelectInput_smode_ET(id = ..1,
                                                                                 col = ..2,
                                                                                 col2 = "Groupe"))
        #updateSelectInput_smode_ET("swordType", "Type", "Groupe")
        # updateSelectInput(session, 
        #                   "swordType", 
        #                   choices = sort(unique(EPoMAB$Type[which(EPoMAB$Groupe %in% input$swordGrp)])))
        # updateSelectInput(session, 
        #                   "swordVar", 
        #                   choices = sort(unique(EPoMAB$Variante[which(EPoMAB$Groupe %in% input$swordGrp)])))
        # updateSelectInput(session, 
        #                   "swordCont", 
        #                   choices = sort(unique(EPoMAB$Contexte[which(EPoMAB$Groupe %in% input$swordGrp)])))
        # updateSelectInput(session, 
        #                   "swordPer", 
        #                   choices = sort(unique(EPoMAB$Periode[which(EPoMAB$Groupe %in% input$swordGrp)])))
        # updateSelectInput(session, 
        #                   "swordPha", 
        #                   choices = sort(unique(EPoMAB$Phase[which(EPoMAB$Groupe %in% input$swordGrp)])))
        # updateSelectInput(session, 
        #                   "swordStep", 
        #                   choices = sort(unique(EPoMAB$Etape[which(EPoMAB$Groupe %in% input$swordGrp)])))
      }
    } else {
      usi_smode_ET_no_Groupe <- purrr::pmap(table_eq[2:7,], updateSelectInput_col)
      # updateSelectInput(session, 
      #                   "swordType", 
      #                   choices = sort(unique(EPoMAB$Type)))
      # updateSelectInput(session, "swordVar", choices = sort(unique(EPoMAB$Variante)))
      # updateSelectInput(session, "swordCont", choices = sort(unique(EPoMAB$Contexte)))
      # updateSelectInput(session, "swordPer", choices = sort(unique(EPoMAB$Periode)))
      # updateSelectInput(session, "swordPha", choices = sort(unique(EPoMAB$Phase)))
      # updateSelectInput(session, "swordStep", choices = sort(unique(EPoMAB$Etape)))
    }
  }, ignoreNULL = FALSE)
  
  observeEvent(input$swordType, {
    if(!is.null(input$swordType)) {
      if(input$search_typo == "ET" | input$search_typo == "AND"){
        usi_smode_ET_Type <- purrr::pmap(table_eq[3:7,], ~updateSelectInput_smode_ET(id = ..1,
                                                                                     col = ..2,
                                                                                     col2 = "Type"))
        # updateSelectInput(session, 
        #                   "swordVar", 
        #                   choices = sort(unique(EPoMAB$Variante[which(EPoMAB$Type %in% input$swordType)])))
        # updateSelectInput(session, 
        #                   "swordCont", 
        #                   choices = sort(unique(EPoMAB$Contexte[which(EPoMAB$Type %in% input$swordType)])))
        # updateSelectInput(session, 
        #                   "swordPer", 
        #                   choices = sort(unique(EPoMAB$Periode[which(EPoMAB$Type %in% input$swordType)])))
        # updateSelectInput(session, 
        #                   "swordPha", 
        #                   choices = sort(unique(EPoMAB$Phase[which(EPoMAB$Type %in% input$swordType)])))
        # updateSelectInput(session, 
        #                   "swordStep", 
        #                   choices = sort(unique(EPoMAB$Etape[which(EPoMAB$Type %in% input$swordType)])))
      }
    } else {
      usi_smode_ET_no_Type <- purrr::pmap(table_eq[3:7,], updateSelectInput_col)
      # updateSelectInput(session, "swordVar", choices = sort(unique(EPoMAB$Variante)))
      # updateSelectInput(session, "swordCont", choices = sort(unique(EPoMAB$Contexte)))
      # updateSelectInput(session, "swordPer", choices = sort(unique(EPoMAB$Periode)))
      # updateSelectInput(session, "swordPha", choices = sort(unique(EPoMAB$Phase)))
      # updateSelectInput(session, "swordStep", choices = sort(unique(EPoMAB$Etape)))
    }
  }, ignoreNULL = FALSE)

  
  ## Reset button
  observeEvent(input$reset, {
    usi_reset <- purrr::pmap(table_eq, updateSelectInput_reset)
    # updateSelectInput(session, "swordGrp", choices = sort(unique(EPoMAB$Groupe)), selected = character(0))
    # updateSelectInput(session, "swordType", choices = sort(unique(EPoMAB$Type)), selected = character(0))
    # updateSelectInput(session, "swordVar", choices = sort(unique(EPoMAB$Variante)), selected = character(0))
    # updateSelectInput(session, "swordCont", choices = sort(unique(EPoMAB$Contexte)), selected = character(0))
    # updateSelectInput(session, "swordPer", choices = sort(unique(EPoMAB$Periode)), selected = character(0))
    # updateSelectInput(session, "swordPha", choices = sort(unique(EPoMAB$Phase)), selected = character(0))
    # updateSelectInput(session, "swordStep", choices = sort(unique(EPoMAB$Etape)), selected = character(0))
    # updateSelectInput(session, "swordCountry", choices = sort(unique(EPoMAB$Pays)), selected = character(0))
    # updateSelectInput(session, "swordReg", choices = sort(unique(EPoMAB$Region)), selected = character(0))
  })
  
  ## Download table button
  output$download.table <- downloadHandler(
    filename = function(){"export.csv"}, 
    content = function(fname){
      write.csv(dataset(), fname, row.names = FALSE)
    }
  )
  
  ## Filtering the data according to the user input
  ## Typologie
  dataset_typo <- reactive({
    data <- EPoMAB
    
    # Initializing dataframes for OR search
    datafam <- data[FALSE,]
    datatype <- data[FALSE,]
    datavar <- data[FALSE,]
    
    if(length(input$swordGrp) | length(input$swordType) | length(input$swordVar)) {
      if(input$search_typo == "ET" | input$search_typo == "AND"){
        if(length(input$swordGrp)){
          data %>% filter(Groupe == input$swordGrp) -> data
        }
        
        if(length(input$swordType)){
          data %>% filter(Type == input$swordType) -> data
        }
        
        if(length(input$swordVar)){
          data %>% filter(Variante == input$swordVar) -> data
        }
        
        data
      } else if(input$search_typo == "OU" | input$search_typo == "OR"){
        if(length(input$swordGrp)){
          data %>% filter(Groupe == input$swordGrp) -> datafam
        }
        
        if(length(input$swordType)){
          data %>% filter(Type == input$swordType) -> datatype
        }
        
        if(length(input$swordVar)){
          data %>% filter(Variante == input$swordVar) -> datavar
        }
        
        if(length(input$swordGrp) | length(input$swordType) | length(input$swordVar)){
          data <- rbind(datafam,datatype,datavar)
          data
        } else {
          data
        }
      }
    } else {
      data
    }
  })
  
  ## Contexts
  dataset_cont <- reactive({
    datacont <- EPoMAB
    if(length(input$swordCont)){
      datacont %>% filter(Contexte == input$swordCont) -> datacont
      datacont
    } else {
      datacont
    }
  })
  
  ## Chronology
  dataset_chrono <- reactive({
    datachrono <- EPoMAB
    if(length(input$swordPer) | length(input$swordPha) | length(input$swordStep)){
      if(input$search_typo == "ET" | input$search_typo == "AND"){
        if(length(input$swordPer)){
          datachrono %>% filter(Periode == input$swordPer) -> datachrono
        }
        if(length(input$swordPha)){
          datachrono %>% filter(Phase == input$swordPha) -> datachrono
        }
        if(length(input$swordStep)){
          datachrono %>% filter(Etape == input$swordStep) -> datachrono
        }
        datachrono
      } else if(input$search_typo == "OU" | input$search_typo == "OR") {
        ## Initializing dataframes for OR search
        dataper <- datachrono[FALSE,]
        datapha <- datachrono[FALSE,]
        datastep <- datachrono[FALSE,]
        
        if(length(input$swordPer)){
          datachrono %>% filter(Periode == input$swordPer) -> dataper
        }
        if(length(input$swordPha)){
          datachrono %>% filter(Phase == input$swordPha) -> datapha
        }
        if(length(input$swordStep)){
          datachrono %>% filter(Etape == input$swordStep) -> datastep
        }
        
        if(length(input$swordPer) | length(input$swordPha) | length(input$swordStep)){
          datachrono <- rbind(dataper,datapha,datastep)
          datachrono
        } else {
          datachrono
        }
      }
    } else {
      datachrono
    }
  })
  
  ## Geography
  dataset_geo <- reactive({
    datageo <- EPoMAB
    if(length(input$swordCountry) | length(input$swordReg)){
      if(input$search_typo == "ET" | input$search_typo == "AND"){
        if(length(input$swordCountry)){
          datageo %>% filter(Pays == input$swordCountry) -> datageo
        }
        if(length(input$swordReg)){
          datageo %>% filter(Region == input$swordReg) -> datageo
        }
        datageo
      } else if(input$search_typo == "OU" | input$search_typo == "OR") {
        ## Initializing dataframes for OR search
        datacountry <- datageo[FALSE,]
        datareg <- datageo[FALSE,]
        
        if(length(input$swordCountry)){
          datageo %>% filter(Pays == input$swordCountry) -> datacountry
        }
        if(length(input$swordReg)){
          datageo %>% filter(Region == input$swordReg) -> datareg
        }
        
        if(length(input$swordCountry) | length(input$swordReg)){
          datageo <- rbind(datacountry,datareg)
          datageo
        } else {
          datageo
        }
      }
    } else {
      datageo
    }
  })
  
  ## Final dataset to be used
  dataset <- reactive({
    typo <- dataset_typo()
    cont <- dataset_cont()
    chrono <- dataset_chrono()
    geo <- dataset_geo()
    datamerge <- Reduce(function(x,y) merge(x, y), list(typo,chrono,cont,geo))
    datamerge <- datamerge[order(datamerge$ID),]
    datamerge
  })
  
  ## Rendering the table from the main panel
  output$table <- DT::renderDataTable({
    DT::datatable(dataset() %>% select(-c("Description","Bibliographie","Commentaires","X","Y")), 
                  rownames = FALSE)
    })
  
  ## Button to switch to map panel
  # observeEvent(input$tomap, {
  #   updateTabsetPanel(session, inputId = "mainpanel", selected = "maptab")
  # })
  
  ## preparing dataset for mapping
  datasetmap <- eventReactive(dataset(), {
    data <- dataset()
    data$label <- "Provenance inconnue"
    data <- data[which(!is.na(data$X) | !is.na(data$Y)),]
    data$X <- as.numeric(data$X)
    data$Y <- as.numeric(data$Y)
    for(i in 1:length(data$ID)) {
      if(!is.na(data$Region[i])) {
        data$label[i] <- data$Region[i]
      }
      if(!is.na(data$Site[i])) {
        data$label[i] <- data$Site[i]
      }
      if(!is.na(data$Commune[i])) {
        data$label[i] <- data$Commune[i]
      }
    }
    data
  }, ignoreNULL = FALSE)
  
  ## Importing river layer
  #rivers <- st_read("www/rivers_simplified.shp", quiet = TRUE)
  #rivers10 <- st_cast(rivers10, "LINESTRING")
  #rivers10 <- st_read("www/rivers.fgb", quiet = TRUE)
  # donau <- st_union(rivers10[which(rivers10$name_fr == "Danube"),])
  # rivers10 <- rivers10[-which(rivers10$rivernum == 38),]
  # rivers10$geometry[which(rivers10$rivernum == 25)] <- donau
  # st_write(rivers10, dsn = "./www/rivers_simplified.shp")
  
  ## Rendering map
  output$swordmap <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles(providers$Esri.WorldTerrain, ## Background map with elevation
                       options = providerTileOptions(noWrap = TRUE,
                                                     minZoom = 3, maxZoom = 9)
                       ) %>% 
      setView(lng = 5, lat = 50, zoom = 5) %>% ## Default view
      setMaxBounds(lng1 = -10, lat1 = 35, ## Maximum user view
                lng2 = 29, lat2 = 65) %>% 
      addDrawToolbar(targetGroup = "draw", position = "topleft",
                     polylineOptions = FALSE,
                     circleOptions = FALSE,
                     markerOptions = FALSE,
                     circleMarkerOptions = FALSE) %>% 
      addPolylines(data = rivers_europe, ## rivers layer
                   color = "darkgrey",
                   opacity = 0.5,
                   stroke = TRUE,
                   weight = 2,
                   layerId = ~ne_id,
                   label = switch(input$lang,
                                  "Fr" = ~name_fr,
                                  "En" = ~name_en,
                                  stop("Option inconnue")
                   ),
                   group = "rivers") %>%
      addPolylines(data = rivers_europe, ## hidden rivers layer
                   color = "red",
                   opacity = 0.5,
                   stroke = TRUE,
                   weight = 3,
                   layerId = ~dissolve,
                   label = switch(input$lang,
                                  "Fr" = ~name_fr,
                                  "En" = ~name_en,
                                  stop("Option inconnue")
                   ),
                   group = ~dissolve) %>%
      addCircles(data = datasetmap(),
                 lng = ~X, lat = ~Y, ## default visible layer
                 fillColor = "blue",
                 fillOpacity = 0.5,
                 color = "blue",
                 stroke = TRUE,
                 weight = 8,
                 layerId = ~ID,
                 group = "points",
                 label = ~label) %>% 
      addCircles(data = datasetmap(),
                 lng = ~X, lat = ~Y, ## hidden layer for manual selection
                 fillColor = "red",
                 fillOpacity = 0.5,
                 weight = 8,
                 color = "red",
                 stroke = TRUE,
                 layerId = ~ID,
                 group = paste0(datasetmap()$Commune,datasetmap()$ID)) %>% 
      hideGroup(group = paste0(datasetmap()$Commune,datasetmap()$ID)) %>% 
      hideGroup(group = rivers_europe$dissolve)
  })
  
  proxy <- leafletProxy("swordmap", session)
  
  ## Preparation for points selection
  selected <- reactiveValues(ids = vector(),
                             riverid = vector(),
                             rivername_fr = vector(),
                             rivername_en = vector())
  show.map.table <- reactiveVal(0)
  show.map.riverbuffer <- reactiveVal(0)
  
  observeEvent(input$swordmap_shape_click, {
    if(input$swordmap_shape_click$group == "points") {
      show.map.table(1)
      selected$ids <- c(selected$ids, input$swordmap_shape_click$id)
      proxy %>% showGroup(group = paste0(EPoMAB$Commune[which(EPoMAB$ID == input$swordmap_shape_click$id)],
                                         input$swordmap_shape_click$id))
    } else if(input$swordmap_shape_click$group %in% paste0(datasetmap()$Commune,datasetmap()$ID)) {
      selected$ids <- setdiff(selected$ids, input$swordmap_shape_click$id)
      proxy %>% hideGroup(group = input$swordmap_shape_click$group)
      if(!length(selected$ids)) {
        show.map.table(0)
      }
    }
    
    if(input$swordmap_shape_click$group == "rivers") {
      if(!is.null(selected$riverid)) {
        proxy %>% hideGroup(group = rivers_europe$dissolve[which(rivers_europe$ne_id == selected$riverid)])
      }
      selected$riverid <- input$swordmap_shape_click$id
      selected$rivername_fr <- rivers_europe$name_fr[which(rivers_europe$ne_id == selected$riverid)]
      selected$rivername_en <- rivers_europe$name_en[which(rivers_europe$ne_id == selected$riverid)]
      proxy %>% showGroup(group = rivers_europe$dissolve[which(rivers_europe$ne_id == selected$riverid)])
      show.map.riverbuffer(1)
    } else if(input$swordmap_shape_click$group %in% rivers_europe$dissolve) {
      proxy %>% hideGroup(group = input$swordmap_shape_click$group)
      show.map.riverbuffer(0)
    }
    #   selected$riverpopup <- paste0("Rivière sélectionnée : ",
    #                        selected$rivername,
    #                        ".<br>",
    #                        numericInput("riverbuffer",
    #                                     "Rayon de sélection (en m) : ",
    #                                     5000,
    #                                     min = 0,
    #                                     max = 100000,
    #                                     step = 1000),
    #                        actionButton("submit.river.buffer", "Sélection",
    #                                     onclick = 'Shiny.onInputChange(\"submit.river.buffer\",  Math.random())'))
    #   proxy %>% addPopups(lng = input$swordmap_shape_click$lng,
    #                       lat = input$swordmap_shape_click$lat,
    #                       popup = selected$riverpopup)
  })
  
  # River buffer button
  observeEvent(input$submit.river.buffer, {
    river <- rivers_europe[which(rivers_europe$ne_id == selected$riverid),]
    riverbuffer <- st_buffer(river, input$riverbuffer)
    proxy %>% addPolygons(data = riverbuffer,
                          weight = 1,
                          stroke = TRUE,
                          fillColor = "#f9eb85",
                          fillOpacity = 0.5,
                          group = "buffer") %>% 
      showGroup(group = "buffer")
    pointslayer <- st_as_sf(datasetmap(), coords = c("X","Y"),
                            dim = "XY", crs = 4326)
    datasetmap() %>% filter(st_intersects(pointslayer, riverbuffer, sparse = FALSE)) ->
      selectedpoints
    if(length(selectedpoints$ID)) {
      selected$ids <- c(selected$ids, selectedpoints$ID)
      show.map.table(1)
      datasetmap() %>%  filter(ID %in% selectedpoints$ID) -> toshow
      proxy %>% showGroup(group = paste0(toshow$Commune,toshow$ID))
    }
  })
  
  #Select all button
  observeEvent(input$map.select.all, {
    selected$ids <- datasetmap()$ID
    proxy %>% showGroup(group = paste0(datasetmap()$Commune,datasetmap()$ID))
    show.map.table(1)
  })
  
  ## Drawn shapes information
  # ReactiveValues to store id leflet shapes drawn by user
  drawnid <- reactiveValues(leafletid = list(),
                            polygons = list(),
                            points = list(),
                            selectedpoints = list())
  
  
  ## Get leaflet id and coordinates drawn polygons
  observeEvent(input$swordmap_draw_all_features, {
    #print(input$swordmap_draw_all_features$features)
    ## Retrieve leaflet id
    drawnid$leafletid <- lapply(
      input$swordmap_draw_all_features$features,
      function(ftr) {
        ftr$properties$`_leaflet_id`
      }
    )
  })
  
  observeEvent(input$swordmap_draw_new_feature, {
    ## Sélection points fonctionne mais différence poly tracé vs
    ## poly sélection : décalage vers le nord. Pourquoi ?
    ## Plus aire tracée est grande, plus décalage est grand...
    ## Question projection sf ?
    
    ## Get cooordinates points each polygons and create them
    drawnid$polygons[length(drawnid$polygons)+1] <- lapply(
      input$swordmap_draw_new_feature$geometry[["coordinates"]],
      function(poly) {
        polycoord <- unlist(poly)
        res <- matrix(polycoord, nrow = length(polycoord)/2, ncol = 2, byrow = TRUE)
        st_sf(st_sfc(st_polygon(list(res))), crs = 4326)
      }
    )

    ## Sf point layers from points displayed on map
    drawnid$points <- st_as_sf(datasetmap(), coords = c("X","Y"),
                               dim = "XY", crs = 4326)
    
    ## Selecting points inside each polygons
    drawnid$selectedpoints <- lapply(
      drawnid$polygons,
      function(select) {
        datasetmap() %>% filter(st_intersects(drawnid$points, select, sparse = FALSE)) ->
          df
        df
      }
    )
    
    ## Use selected points to select and display them on the map
    selectedids <- lapply(
      drawnid$selectedpoints,
      function(selectids) {
        if(length(selectids$ID)) {
          selectids$ID
        }
      }
    )
    selectedids <- unlist(selectedids)
    selected$ids <- c(selected$ids, unique(selectedids))
    if(length(selectedids)) {
      show.map.table(1)
      datasetmap() %>%  filter(ID %in% selectedids) -> toshow
      proxy %>% showGroup(group = paste0(toshow$Commune,toshow$ID))
    }
  })
  
  #Reset map selection button
  observeEvent(input$reset.map.selection, {
    #selected$ids <- c()
    proxy %>% hideGroup(group = c(paste0(datasetmap()$Commune,datasetmap()$ID),
                                  rivers_europe$dissolve[which(rivers_europe$ne_id == selected$riverid)])
                        ) %>% 
              clearGroup(group = "buffer")
    lapply(X = names(selected),
           FUN = function(x) {
             selected[[x]] <- NULL
           })
    show.map.table(0)
    show.map.riverbuffer(0)
    ## Remove drawn shapes
    lid <- drawnid$leafletid
    lapply(X = names(drawnid),
           FUN = function(x) {
             drawnid[[x]] <- NULL
           })
    #print(drawnid$polygons)
    # remove drawn polygos with script in app_ui.R
    lapply(lid,
           function(todelete) {
             session$sendCustomMessage(
               "removeleaflet",
               list(elid="swordmap", layerid=todelete)
             )
           }
          )
    river <- NULL
    riverbuffer <- NULL
    pointslayer <- NULL
    selectedpoints <- NULL
    toshow <- NULL
  })
  
  ## Displaying information for clicked point
  maptable <- reactive({
    EPoMAB %>% filter(ID %in% selected$ids) -> clickeddata
    clickeddata <- clickeddata[order(clickeddata$ID),]
    clickeddata
  })
  
  output$clickedpoint <- renderUI(
    expr = if(show.map.table()) {
      DT::dataTableOutput("clickedpoint.table")
    }
  )
  
  output$riverbuffer <- renderUI(
    expr= if(show.map.riverbuffer()) {
      fluidRow(
               paste0(switch(input$lang,
                        "Fr" = "Rivière sélectionnée : ",
                        "En" = "Selected river: ",
                        stop("Option inconnue")
                      ),
                      switch(input$lang,
                             "Fr" = selected$rivername_fr,
                             "En" = selected$rivername_en,
                             stop("Option inconnue")
                      )
                      ),
               br(),
               numericInput("riverbuffer",
                            #"Sélection dans un rayon de (en m) :",
                            switch(input$lang,
                                   "Fr" = "Sélection dans un rayon de (en m) :",
                                   "En" = "Selection within a radius of (in m):",
                                   stop("Option inconnue")
                            ),
                            5000,
                            min = 0,
                            max = 100000,
                            step = 1000),
                   br(),
                   actionButton("submit.river.buffer", textOutput("map.selection"))
        )#,
        # column(1,
        #        br(),
        #        actionButton("submit.river.buffer", "Sélection")
        # )
    }
  )

  output$clickedpoint.table <- DT::renderDataTable({
    DT::datatable(data = maptable()%>% select(-c("Description","Bibliographie","Commentaires","X","Y")),
                  rownames = FALSE,
                  options=list(dom = "tp")
                  )
  })
  
  ## Display download button is point selected
  output$button.table.map <- renderUI(
    expr = if(show.map.table()){
      downloadButton("download.table.map", textOutput("download.map",
                                                     inline = T))
    } else {
      NULL
    }
  )
  
  ## Download table selected point
  output$download.table.map <- downloadHandler(
    filename = function(){"export.csv"}, 
    content = function(fname){
      write.csv(maptable(), fname, row.names = FALSE)
    }
  )
}
