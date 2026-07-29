library(tidyverse)

#-------------------------
# Read files
#-------------------------

path <- read_tsv("path_abun_unstrat.tsv.gz")

map <- read_tsv(
  "metacyc_pathways_info.txt.gz",
  col_names = c("pathway_id", "pathway_name")
)

meta <- read_tsv("metadata.tsv") %>%
  select(`sample-id`, isolate)

#-------------------------
# Annotate pathway names
#-------------------------

path <- path %>%
  left_join(map, by = c("pathway" = "pathway_id"))

#-------------------------
# Keywords related to skin biology
#-------------------------

keywords <- c(
  "fatty",
  "lipid",
  "glycer",
  "phospholipid",
  "acetyl",
  "acetate",
  "ceramide",
  "sphingo",
  "serine",
  "glycine",
  "arginine",
  "histidine",
  "methionine",
  "pyruvate",
  "lactate",
  "folate",
  "biotin",
  "riboflavin",
  "pantothenate",
  "vitamin",
  "coenzyme",
  "lipopolysaccharide",
  "peptidoglycan"
)

keywords <- c(
  keywords,
  "oleate",
  "palmitate",
  "stearate",
  "isoleucine",
  "leucine",
  "valine",
  "tryptophan",
  "tyrosine",
  "phenylalanine",
  "glutathione",
  "sulfur",
  "heme",
  "porphyrin",
  "quinone",
  "menaquinone",
  "ubiquinone",
  "coa",
  "coenzyme a",
  "isoprenoid",
  "terpenoid"
)

#-------------------------
# Keep only skin-related pathways
#-------------------------

skin_pathways <- path %>%
  filter(str_detect(
    tolower(pathway_name),
    paste(keywords, collapse="|")
  ))

#-------------------------
# Which keyword matched?
#-------------------------

skin_pathways$matched_keyword <-
  sapply(
    tolower(skin_pathways$pathway_name),
    function(x){
      
      hit <- keywords[str_detect(x, keywords)]
      
      if(length(hit)==0) NA else paste(hit, collapse=", ")
      
    }
  )

#-------------------------
# Convert to long format
#-------------------------

skin_long <- skin_pathways %>%
  
  pivot_longer(
    
    cols = -c(pathway,
              pathway_name,
              matched_keyword),
    
    names_to="sample",
    
    values_to="abundance"
    
  )

#-------------------------
# Add tissue information
#-------------------------

skin_long <- skin_long %>%
  
  left_join(
    meta,
    by=c("sample"="sample-id")
  )

#-------------------------
# Rename isolate
#-------------------------

skin_long <- skin_long %>%
  
  rename(Tissue=isolate)

#-------------------------
# Save
#-------------------------

write.csv(
  skin_long,
  "Skin_Pathway_Table_AllSamples.csv",
  row.names=FALSE
)

cat("Rows:",nrow(skin_long),"\n")
cat("Unique pathways:",length(unique(skin_long$pathway)),"\n")
