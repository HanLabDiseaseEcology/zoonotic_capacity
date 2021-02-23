###README for input files associated with Fischhoff et al. 2021 Predicting zoonotic capacity of mammal species for SARS-CoV-2 
#####Trait variables used for modeling zoonotic capacity are from PanTHERIA, EltonTraits, AnAge, Amniote Life History Database, AmphiBIO, FishBase, Meiri 2018, Meiri 2019, and a data file for CITES listed turtles and tortoises. For information on where each trait variable was originally found, see Tables 2 and 3 in Supplementary File 2. Additional information on units for each variable is also found in Tables 2 and 3.
#####File names included as input files are MammalTrainingData080221_NvAdded, MammalTrainingData080221_wildCategory_NvAdded, VertsTrainingData080221_NvHaddockAdded, and MammalPredictionData231220_wildCategory
###Column names
Species: Name of species traits belong to
ForStrat_terrestrial: forages in terrestrial habitats
ForStrat_aquatic: forages in aquatic habitats (freshwater or marine)
Activity.Nocturnal: active during the night
Activity.Crepuscular: active during twilight
Activity.Diurnal: active during the day
female_maturity_d: time to maturity for female individuals
male_maturity_d: time to maturity for male individuals
weaning_d: weaning duration
development_d: gestation/incubation time
log_litterclutch_size_n: log transformed size of litter/clutch
litters_or_clutches_per_y: number of litters or clutches in a year
log_inter_litterbirth_interval_y: log transformed time between litters/clutches
log_birthhatching_weight_g: log transformed weight at birth/hatching
log_weaning_weight_g: log transformed weight at weaning
log_adult_body_mass_g: log transformed body mass of an adult individual
infantMortalityRate_per_year: infant mortality rate
mortalityRateDoublingTime_y: mortality rate doubling time
metabolicRate_W: basal metabolic rate
temperature_K: typical body temperature
longevity_y: mean longevity of an individual
log_female_body_mass_g: log transformed body mass of a female individual
log_male_body_mass_g: log transformed body mass of a male individual
adult_svl_cm: snout vent length of adults
diet_breadth: percentage of diet categories
tnc_ecoregion_breadth: percentage of ecoregions covered by a species
mass_specific_production: mass specific production for a species
log_range_size: size of distribution polygon
AA_83_y: residue at ACE2 position 83 is a Y (Tyrosine)
AA_30_negative: residue at ACE2 position 30 is negatively charged
log_WOS_hits_synonyms: log_transformed number of publications found by a Web of Science topic (title and abstract) search for a species, including synonyms based on GBIF backbone
nchar: length of amino acid sequence
haddock_score_mean: mean HADDOCK score determined for this species (measured in arbitrary units)
haddock_score_sd: standard deviation of the HADDOCK score for this species

Columns found only in vertebrates training dataset (VertsTrainingData080221):
ForStrat.ground: forages on the ground (or inland waters)
ForStrat.understory: forages below 2 m in the forest
ForStrat.arboreal: forages in trees
ForStrat.aerial: foreages above vegetation or structures
ForStrat.marine: forages in open oceanic bodies
ClassActinopterygii: belongs to class Actinopterygii
ClassAmphibia: belongs to class Amphibia
ClassAves: belongs to class Aves
ClassElasmobranchii: belongs to class Elasmobranchii
ClassHolocephali: belongs to class Holocephali
ClassMammalia: belongs to the best class, Mammalia
ClassReptilia: belongs to classReptilia

Columns found only in the mammal training and prediction datasets (all other files):
Afrosoricida: belongs to order Afrosoricida
Artiodactyla: belongs to order Artiodactyla
Carnivora: belongs to order Carnivora
Cetacea: belonged to the order once known as Cetacea (now subsumed into Artiodactyla)
Chiroptera: belongs to the order Chiroptera
Cingulata: belongs to the order Cingulata
Dasyuromorphia: belongs to the order Dasyuromorphia
Didelphimorphia: belongs to the order Didelphimorphia
Diprotodontia: belongs to the order Diprotodontia
Erinaceomorphia: belonged to the order once known as Erinaceomorphia (now within Eulipotyphla)
Lagomorpha: belongs to the order Lagomorpha
Macroscelidea: belongs to the order Macroscelidea
Monotremata: belongs to the order Monotremata
Perrisodactyla: belongs to the order Perrisodactyla
Pholidota: belongs to the order Pholidota
Primates: belongs to the order Primates
Proboscidea: belongs to the order Proboscidea
Rodentia: it's a rodent!
Sirenia: belongs to the order Sirenia
Soricomorpha: belonged to the order once known as Soricomorpha (now within Eulipotyphla)
Tubulidentata: belongs to the order Tubulidentata