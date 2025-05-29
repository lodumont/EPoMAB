## Retrieving data from the Heurist database
## Based on the heurist-etl-pipeline python script 
## (https://lostma-erc.github.io/heurist-etl-pipeline/)
## 2025-05-01
## Léonard Dumont

# library(duckdb)
# library(dplyr)
# library(tidyr)
# library(janitor)
# library(stringr)
# 
# # Read the heurist script from the txt file
# script <- readLines("./heurist/heurist.txt")
# 
# # Run the script
# system(script[1]) # activate python virtual environment
# system(script[2]) # download heurist database
# 
# # Connect to the database file
# con <- dbConnect(duckdb(), dbdir = "./data/dumont_swords.db")
# 
# # Retrieve swords and sites tables
# swords <- dbGetQuery(con, "SELECT * FROM Epee") %>% clean_names()
# sites <- dbGetQuery(con, "SELECT * FROM Site") %>% clean_names()
# 
# # Create EPOMAB dataset
# EPoMAB_heurist <- inner_join(swords, sites, # join sites and swords dataframes
#                      by = join_by(id_site_h_id == h_id)) %>% 
#   select(c(ID = id_epee, # select and rename columns
#            Pays = pays,
#            Region = region,
#            Departement = departement,
#            Commune = commune,
#            Site = site,
#            Categorie = categorie,
#            Groupe = groupe,
#            Type = type_column,
#            Variante = variante,
#            Contexte = contexte,
#            Periode = periode,
#            Phase = phase,
#            Etape = etape,
#            Indice_confiance = indice_confiance,
#            Typo_techno = typo_techno,
#            Emmanchement = emmanchement,
#            Canal_pommeau = canal_pommeau,
#            Construction_pommeau = fixation_pommeau,
#            Description = description,
#            Longueur = longueur_totale,
#            Conservation = lieu_conservation,
#            Inventaire = inventaire,
#            Bibliographie = bibliographie,
#            Commentaires = commentaires,
#            Coordonnees = mappable_location)) %>%
#   # Change column with coordinates for compatibility with sf
#   mutate(Coordonnees = str_replace(Coordonnees, "POINT", "POINT "))
# 
# # save dataset
# save(EPoMAB_heurist, file = "./data/EPoMAB_heurist.rda")
# 
# # load updated dataset
# load("./data/EPoMAB_heurist.rda")

# Now into a function
heurist2epomab <- function(){
  require(duckdb)
  require(dplyr)
  require(tidyr)
  require(janitor)
  require(stringr)
  
  # Read the heurist script from the txt file
  script <- readLines("./heurist/heurist.txt")
  
  # Run the script
  #system(script[1]) # activate python virtual environment
  system(script[2]) # download heurist database
  
  # Connect to the database file
  con <- dbConnect(duckdb(), dbdir = "./data/dumont_swords.db")
  
  # Retrieve swords and sites tables
  swords <- dbGetQuery(con, "SELECT * FROM Epee") %>% clean_names()
  sites <- dbGetQuery(con, "SELECT * FROM Site") %>% clean_names()
  
  # Create EPOMAB dataset
  EPoMAB_heurist <- inner_join(swords, sites, # join sites and swords dataframes
                               by = join_by(id_site_h_id == h_id)) %>% 
    select(c(ID = id_epee, # select and rename columns
             Pays = pays,
             Region = region,
             Departement = departement,
             Commune = commune,
             Site = site,
             Categorie = categorie,
             Groupe = groupe,
             Type = type_column,
             Variante = variante,
             Contexte = contexte,
             Periode = periode,
             Phase = phase,
             Etape = etape,
             Indice_confiance = indice_confiance,
             Typo_techno = typo_techno,
             Emmanchement = emmanchement,
             Canal_pommeau = canal_pommeau,
             Construction_pommeau = fixation_pommeau,
             Description = description,
             Longueur = longueur_totale,
             Conservation = lieu_conservation,
             Inventaire = inventaire,
             Bibliographie = bibliographie,
             Commentaires = commentaires,
             Coordonnees = mappable_location)) %>%
    # Change column with coordinates for compatibility with sf
    mutate(Coordonnees = str_replace(Coordonnees, "POINT", "POINT "))
  
  # save dataset
  save(EPoMAB_heurist, file = "./data/EPoMAB_heurist.rda")
} 
