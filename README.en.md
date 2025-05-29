European Bronze Age solid-hilted swords database
================

[![DOI](https://zenodo.org/badge/778354510.svg)](https://doi.org/10.5281/zenodo.10913139)

The `EPoMAB` database is an R Shiny application allowing you to interactively explore the inventory of European Bronze Age solid-hilted swords. It is possible to explore the dataset containing information on the typology, chronology, technology and discovery contexts of the inventoried swords via a table and a distribution map. The dataset differs from one available in the dat\@UBFC repository (<https://doi.org/10.25666/DATAUBFC-2024-03-06>) in that the data here is regularly updated based on new discoveries and new studies carried out on these objects.

## Presentation of the dataset

The dataset currently has 2780 records described using 27 variables:

  - **ID** : unique identifier for each sword, assigned arbitrarily.
  - **Pays** : country of origin of the sword.
  - **Region** : administrative region of discovery. The administrative subdivisions are based on the French model of regions and departments. The regions correspond to the German *Länder*.
  - **Departement** : administrative department of discovery. The départements correspond to the German arrondissements (*Landkreise*).
  - **Commune** : municipality of the find. In the case of objects of undetermined provenance, "Provenance inconnue" is indicated in this column.
  - **Site** : site of the find, if known. This field provides additional information in relation to the commune: for example, the name of the hamlet, locality or street in which the find was made.
  - **Categorie** : artefacts in the database fall into four main categories :
    - "Épée à poignée métallique" : swords with hilts made entirely of metal.
    - "Épée à poignée semi-métallique": swords with hilts made of a combination of metal and organic materials (typically bone).
    - "Moule" : mould used to cast sword hilts.
    - "Autre" : objects inventoried but placed separately because of uncertainty about their nature, as in the case of carp-tongue swords of the Venat type, which could have been fitted with a sword hilt.
    - "Indéterminé" : objects published as possible hilts elements, with no certainty.
    - "Faux / copie" : modern casts and counterfeits that were published as genuine Bronze Age swords.
  - **Groupe** : first typological subdivision level.
  - **Type** : second typological subdivision level.
  - **Variante** : third typological subdivision level.
  - **Contexte** : context of the find, falling in the 8 following categories:
    - "Dépôt" : sword found in a hoard, with other artefacts.
    - "Milieu humide" : sword found in a wet context, such as a river, a lake or a bog.
    - "Funéraire" : sword found in a funerary context.
    - "Palafitte" : sword found in a lake-dwelling; these are generally old finds for which it is impossible to determine whether the object comes from the settlement or not.
    - "Domestique" : sword found within domestic structures (habitat or nearby waste).
    - "Sanctuaire" : sword found in a sanctuary (such as the Heraion from Samos).
    - "Isolé" : swords apparently found alone; these may be objects that were genuinely found on their own, such as the sword from Pont-sur-Seine, or chance finds that are poorly documented and may have come from a deposit or burial site.
    - "Inconnu" : unknown context.
  - **Periode** : chronological periode (for example : "Bronze final).
  - **Phase** : chronological phase (for example: Bronze final 3).
  - **Etape** : chronological step (for example: Bronze final 3b).
  - **Indice_confiance** : confidence index concerning the technological data:
    - 1 : sword only known through text sources.
    - 2 : sword known through graphic documentation (drawings, pictures...).
    - 3 : sword seen and studied at a macroscopic level.
    - 4 : sword investigated using X-ray imaging technique (radiography, CT-scan).
  - **Typo_techno** : technological type the sword belongs to, determined using X-ray imaging techniques (confidence index 4). For more information regarding the technological classification, see [the author's dissertation](https://theses.hal.science/tel-03815132) (p 147-151).
  - **Emmanchement** : techniques used to fit the hilt to the blade. The reliability of this data depends on the way they were acquires (see **Indice de confiance**). Several values are possible (see [the author's dissertation](https://theses.hal.science/tel-03815132), p. 117-145):
    - "Rivets" : fixation using rivets.
    - "Blocage" : fixation by mecanical contact between the bland and the hilt.
    - "Rivets+Blocage" : both techniques combined.
    - "Sur-coulée" : hilt cast over the blade.
    - "Un seul bloc" : hilt and blade cast in one piece.
    - "Autre" : other techniques.
    - "Indéterminé" : unknown technique.
  - **Canal_pommeau** : tell the presence (1) or absence (0) of a canal within the pommel of the hilt (see [the author's dissertation](https://theses.hal.science/tel-03815132), p 134-135).
  - **Construction_pommeau** : technique used to attach the pommel to the rest of the hilt:
    - "Coulé" : the pommel is cast in one piece with the rest of the hilt.
    - "Sur-coulée" : the pommel is cast over the top of the hilt.
    - "Rivetage tige centrale" : the pommel is riveted to the hilt through a central shaft (mostly within types Auvernier and Tachnlovice).
    - "Rivetage latéral" : the pommel is fixed to the hilt using rivets on both sides (type Tachlovice).
    - "Encastré" : the pommel is embedded in or fitted on a support.
    - "Autre" : other techniques.
    - "Indéterminé" : unknown technique.
  - **Description** : description of the artefact.
  - **Longueur** : length of the sword (in cm).
  - **Conservation** : place where the sword is curated.
  - **Inventaire** : inventory number.
  - **Bibliographie** : references concerning the swords (in "Author-Year" format) ; see the list under the "Bibliography" tab.
  - **Commentaires** : comments on the swords.
  - **X** : longitude (WGS-84). Coordinates usually match the municipality centroid.
  - **Y** : latitude (WGS-84). Coordinates usually match the municipality centroid.

## Exploring the dataset

#### Table

The application's 'Table' tab lets you explore the dataset in the form of a table. This is displayed in the right-hand panel. The columns 'Description', 'Commentaires', 'Bibliographie', 'X' and 'Y' are not displayed to make the data easier to read. However, these headings are included in the `csv` file, which can be obtained by clicking on the 'Download' button.

The panel on the left allows you to filter records according to different search criteria. The following filters are currently implemented:

  - Typology (Group, Type and Variant).
  - Context.
  - Chronology (Period, Phase and Stage).
  - Geography (Country and Region).
  
By default, searches are performed in "AND" mode. The values proposed in the search fields are thus restricted according to the criteria chosen. For example, by selecting "Antennes" in the "Group" field, only types of sword with antennae will be available in the "Type" field. By ticking 'OR' under 'Search mode' at the top of the table, you can search for swords belonging to different groups or types. The "Reset" button is used to return to the display of all the records and delete the search criteria.

#### Map

In the 'Map' tab, you can explore the same dataset using a distribution map. Each blue circle corresponds to a record. The name of the commune of discovery is displayed when the cursor passes over a circle. Points can be selected manually by clicking on them. Selected points turn red and the corresponding data is displayed in the form of a table below the map. Points can be deselected manually by clicking on them again or by pressing the "Reset" button.

Selection can also be made using the two tools in the sidebar of the map, represented by a polygon and a square. By choosing the square tool, you can select points by drawing a rectangular area. The polygon tool can be used to draw a more complex shape to which each click adds an angle. Several selection areas can be defined using these tools. The 'Reset' button can be used to erase selections.

Finally, it is also possible to select recordings from the rivers displayed on the map. The main European rivers appear in grey on the map. Move the cursor over them to display the river name. By clicking, the river is selected and appears in red. In the right panel, the name of the selected river is displayed, along with a field for entering a distance. Click on "Selection" to select the swords located within the chosen radius around the selected river.

The different methods (manual selection, based on a geographical area or distance to a watercourse) are complementary and can be used in conjunction with each other. Once the points have been selected, the corresponding data can be exported in 'csv' format using the 'Download' button. 

## Roadmap

In the near future, several points need to be improved and implemented:

  - Addition of queries based on technological criteria in the table.
  - Possibility of customising and exporting distribution maps.

## Contact

The European Bronze Age solid-hilted swords database is developped and maintained by [Léonard Dumont](mailto:leonard.dumont@u-bourgogne.fr), researcher associated to the UMR 6298 ARTEHIS lab (Université de Bourgogne, CNRS, Ministère de la Culture et de la Communication) and to the Department of Archaeology at Ghent University.

## References

#### PhD dissertation

  - L. Dumont (2022) – *Production et circulation des épées à poignée métallique de l'âge du Bronze*, Ghent University and Université de Bourgogne-Franche-Comté, 781 p., <https://theses.hal.science/tel-03815132>
