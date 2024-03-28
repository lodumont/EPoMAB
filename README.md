Base Épées à poignée métallique de l'âge du Bronze (EPoMAB)
================

La base `EPoMAB` est une application R Shiny permettant d'explorer de manière interactive l'inventaire des épées à poignée métallique de l'âge du Bronze en Europe. Il est possible d'y explorer le jeu de données contenant des informations sur la typologie, la chronologie, la technologie et les contextes de découverte des épées inventoriées par l'intermédiaire d'un tableau et d'une carte de répartition. Le jeu de données diffère de celui hébergé par la plateforme dat\@UBFC (<https://doi.org/10.25666/DATAUBFC-2024-03-06>) dans la mesure où les données sont ici régulièrement mises à jour en fonction des nouvelles découvertes et des nouvelles études menées sur ces objets.

## Présentation des données.

Le jeu de données compte à l'heure actuelle 2780 enregistrements décrits à l'aide de 27 variables :

  - **ID** : identifiant unique propre à chaque épée, attribué arbitrairement.
  - **Pays** : pays dans lequel l'épée a été découverte.
  - **Region** : region administrative de la découverte. Les subdivisions administratives sont fondées sur le modèle français des régions et des départements. Les régions correspondent aux *Länder* allemands.
  - **Departement** : département administratif de la découverte. Les départements correspondent aux arrondissements (*Landkreise*) allemands.
  - **Commune** : commune de la découverte. Dans le cas d'objets de provenance indéterminée, la mention "Provenance inconnue" est indiquée dans cette colonne.
  - **Site** : site de la découverte, lorsque celui-ci est connu. Ce champ apporte une précision supplémentaire par rapport à la commune : il s'agit par exemple du nom du hameau, du lieu-dit ou de la rue dans laquelle la découverte a été effectuée.
  - **Categorie** : les objets inventoriés se répartissent en quatre grandes catégories :
    - "Épée à poignée métallique" : épées dont la poignée est entièrement entièrement en bronze.
    - "Épée à poignée semi-métallique": épées dont la poignée est formée d'une association de bronze et de matériaux périssables, comme de l'os.
    - "Moule" : moule ayant servi à la production de poignées d'épée en bronze.
    - "Autre" : objets inventoriés mais placés à part en raison de l'incertitude concernant leur nature, comme pour les épées en langue de carpe du type Vénat qui pourraient être dotées d'un pommeau partiellement métallique.
    - "Indéterminé" : éléments mentionnés dans la littérature comme ayant pu appartenir à une poignée d'épée, sans que cela soit confirmé.
    - "Faux / copie" : copies, faux et contrefaçons moderne qui ont été confondues avec de véritables épées protohistoriques.
  - **Groupe** : premier niveau de subdivision typologique.
  - **Type** : second niveau de subdivision typologique, comme pour les épées du type Mörigen.
  - **Variante** : troisième et dernier niveau de subdivision typologique, peut apporter des précisions utiles comme pour les épées hybrides alliant des caractéristiques de types normalement distincts.
  - **Contexte** : contexte de la découverte. Huit valeurs sont possibles :
    - "Dépôt" : épée issue d'un dépôt terrestre, associée à d'autres objets.
    - "Milieu humide" : épée découverte dans un contexte humide tel qu'une rivière, un lac ou une tourbière.
    - "Funéraire" : épée découverte au sein d'une sépulture.
    - "Palafitte" : épée découvert au sein d'un site lacustre ; il s'agit généralement de découvertes anciennes pour lesquelles il est impossible de déterminer si l'arme provient d'un habitat ou non.
    - "Domestique" : épée découverte au sein de structures domestiques (habitat ou rejet à proximité).
    - "Sanctuaire" : épée découverte en contexte de sanctuaire (ne concerne que l'épée trouvée au sein de l'heraion de Samos et quelques découvertes en grotte).
    - "Isolé" : épée apparemment découverte de manière isolée ; il peut s'agir d'objets véritablement trouvés seuls, comme l'épée de Pont-sur-Seine, ou bien de découvertes fortuites mal documentées, qui pourraient être issues d'un dépôt ou d'une sépulture.
    - "Inconnu" : contexte indéterminé.
  - **Periode** : période chronologique (par exemple : Bronze final).
  - **Phase** : phase chronologique (par exemple : Bronze final 3).
  - **Etape** : étape chronologique (par exemple: Bronze final 3b).
  - **Indice_confiance** : indice de confiance permettant de juger de la qualité des informations technologiques disponibles sur l'épée :
    - 1 : épée connue uniquement par l'intermédiaire de descriptions textuelles.
    - 2 : épée étudiée par l'intermédiaire d'une documentation graphique (photographies, dessins…).
    - 3 : épée ayant fait l'objet d'une étude macroscopique.
    - 4 : épée dont les techniques de production ont été étudiées par des examens d'imagerie par rayons X (radiographie, tomographie).
  - **Typo_techno** : type technologique auquel appartient l'épée, lorsque celui-ci a pu être déterminé sur la base d'examens d'imagerie par rayons X (indice de confiance 4). Pour plus d'informations sur le système de classification typo-technologique, se référer à [la thèse de l'auteur](https://theses.hal.science/tel-03815132) (p 147-151).
  - **Emmanchement** : méthode(s) utilisée(s) pour fixer la poignée à la lame. Attention, la fiabilité de ces données est variable selon la manière dont ont été acquises ces données (voir **Indice_confiance**). Plusieurs valeurs sont possibles (se référer à [la thèse de l'auteur](https://theses.hal.science/tel-03815132), p. 117-145) :
    - "Rivets" : fixation à l'aide de rivets.
    - "Blocage" : fixation réalisée par contact mécanique entre la lame et la poignée.
    - "Rivets+Blocage" : combinaison des deux techniques précédentes.
    - "Sur-coulée" : poignée coulée directement sur le sommet de la lame.
    - "Un seul bloc" : lame et poignée coulée d'un seul jet.
    - "Autre" : autres techniques.
    - "Indéterminé" : technique inconnue.
  - **Canal_pommeau** : indique la présence (1) ou l'absence (0) d'un canal au sein du pommeau (se référer à [la thèse de l'auteur](https://theses.hal.science/tel-03815132), p 134-135).
  - **Construction_pommeau** : description de la technique utilisée pour attacher le pommeau de l'épée au reste de la poignée :
    - "Coulé" : le pommeau est coulée d'un seul bloc avec le reste de la poignée.
    - "Sur-coulée" : le pommeau a été coulé par dessus la fusée.
    - "Rivetage tige centrale" : le pommeau a été riveté à la fusée en utilisant une tige centrale (essentiellement types Auvernier et Tachnlovice).
    - "Rivetage latéral" : le pommeau a été riveté au sommet de la fusée par ses extrémités (type Tachlovice).
    - "Encastré" : pommeau encastré sur un support (typiquement un pommeau en matière organique encastré sur une tige).
    - "Autre" : autres techniques.
    - "Indéterminé" : technique indéterminée.
  - **Description** : description de l'objet.
  - **Longueur** : longueur conservée de l'objet (en cm).
  - **Conservation** : lieu de conservation de l'épée.
  - **Inventaire** : numéro d'inventaire au sein du lieu de conservation.
  - **Bibliographie** : références bibliographiques traitant de l'épée, au format "Auteur(s) (année)" ; se référer à la liste fournie sous l'onglet "Bibliographie".
  - **Commentaires** : commentaires sur l'épée, sur son histoire (ventes, différents propriétaires), les erreurs bibliographiques la concernant, ou encore les sites internet la mentionnant dans le cas de découvertes inédites.
  - **X** : longitude (WGS-84). Les coordonnées correspondent généralement au centroïde de la commune de découverte.
  - **Y** : latitude (WGS-84). Les coordonnées correspondent généralement au centroïde de la commune de découverte.

## Exploriation des données

#### Tableau

L'onglet `Tableau` de l'application permet d'explorer les données sous la forme d'un tableau. Celui-ci est affiché dans le panneau de droite. Les rubriques "Description", "Commentaires", "Bibliographie", "X" et "Y" ne sont pas affichées afin de garantir une meilleure lecture des données. Ces rubriques sont en revanche incluses dans le fichier `csv` qu'il est possible d'obtenir via le bouton "Télécharger".

Le panneau de gauche permet de filtrer les enregistrements selon différents critère de recherche. Les filtres suivants sont implémentés à l'heure actuelle :

  - Typologie (Groupe, Type et Variante).
  - Contexte.
  - Chronologie (Période, Phase et Etape).
  - Géographie (Pays et Region).
  
Par défaut, les recherches s'effectuent en mode "ET". Les valeurs proposées dans les champs de recherche sont ainsi restreintes selon les critères choisis. Par exemple, en sélectionnant "Antennes" dans le champ "Groupe", seuls les types d'épées à antennes seront disponibles dans le champ "Type". En cochant "OU" sous "Mode de recherche" au dessus du tableau, il est possible de rechercher les épées appartenant à différents groupes ou types. Le bouton "Reset" permet de revenir à l'affichage de l'ensemble des enregistrements et d'effacer les critères de recherche.

#### Carte

Sous l'onglet `Carte`, il est possible d'explorer ce même jeu de données par l'intermédiaire d'une carte de répartition. Chaque cercle bleu correspond à un enregistrement. Le nom de la commune de la découverte s'affiche lorsque le curseur passe sur un cercle. Les points peuvent être sélectionner manuellement en cliquant dessus. Les points sélectionnés deviennent rouges et les données correspondantes s'affichent sous la forme d'un tableau sous la carte. Les points peuvent être déselectionnés manuellement en cliquant à nouveau dessus ou bien en appuyant sur le bouton "Reset".

La sélection peut également s'effectuer grâce aux deux outils présent dans la barre latérale de la carte, représentés par un polygone et un carré. En choisissant ce dernier, il est possible de sélectionner des points en traçant une aire de forme rectangulaire. L'outil polygone permet quant à lui de tracer une forme plus complexe à laquelle chaque clic ajoute un angle. Il est possible de définir plusieurs zones de sélection à l'aide de ces outils. Le bouton "Reset" permet d'effacer les sélections.

Finalement, il est également possible de sélectionner les enregistrements à partir des cours d'eau affichés sur la carte. Les principaux cours d'eau européens apparaissent en gris sur la carte. En passant le curseur par dessus, le nom du cours d'eau s'affiche. En cliquant, le cours d'eau est sélectionné et apparaît en rouge. Sous la carte, le nom du cours d'eau sélectionné s'affiche ainsi qu'un champ permettant de renseigner une distance. En cliquant sur "Sélection", 

Les différentes méthodes (sélection manuelle, à partir d'une aire géographique ou de la distance à un cours d'eau) sont complémentaires et peuvent être utilisées conjointement. Une fois les points sélectionnés, il est possible d'exporter les données correspondantes au format `csv` en utilisant l bouton "Télécharger". 

## Feuille de route

Dans un futur proche, plusiers points devront être améliorés :

  - Développement d'une interface multilingue (au moins français-anglais).
  - Ajout de requêtes à partir de critères technologiques dans le tableau.
  - Possibilité de personnaliser et d'exporter des cartes de répartition.

## Contact

La base Épées à poignée métallique de l'âge du Bronze est développpée et maintenue par [Léonard Dumont](mailto:leonard.dumont@u-bourgogne.fr), rattaché à l'UMR 6298 ARTEHIS (Université de Bourgogne, CNRS, Ministère de la Culture et de la Communication) et au département d'archéologie de la Ghent University.

## Références

#### Thèse de doctorat

  - L. Dumont (2022) – Production et circulation des épées à poignée métallique de l'âge du Bronze, Ghent University et Université de Bourgogne-Franche-Comté, 781 p., <https://theses.hal.science/tel-03815132>
