library(readr)
library(dplyr)

map <- read_tsv(
  "metacyc_pathways_info.txt.gz",
  col_names = c("pathway_id", "pathway_name")
)

head(map)

axilla_annot <- axilla %>%
  left_join(map, by = c("taxon" = "pathway_id")) %>%
  relocate(pathway_name, .after = taxon)

scalp_annot <- scalp %>%
  left_join(map, by = c("taxon" = "pathway_id")) %>%
  relocate(pathway_name, .after = taxon)

scalp_axilla_annot <- scalp_axilla %>%
  left_join(map, by = c("taxon" = "pathway_id")) %>%
  relocate(pathway_name, .after = taxon)

write.csv(
  axilla_annot,
  "Results/ANCOMBC2_Pathways_Axilla_vs_Arm_Annotated.csv",
  row.names = FALSE
)

write.csv(
  scalp_annot,
  "Results/ANCOMBC2_Pathways_Scalp_vs_Arm_Annotated.csv",
  row.names = FALSE
)

write.csv(
  scalp_axilla_annot,
  "Results/ANCOMBC2_Pathways_Scalp_vs_Axilla_Annotated.csv",
  row.names = FALSE
)

head(
  scalp_annot %>%
    select(
      taxon,
      pathway_name,
      lfc_isolateAxilla,
      q_isolateAxilla
    )
)
