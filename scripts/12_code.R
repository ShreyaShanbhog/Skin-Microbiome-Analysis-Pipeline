library(tidyverse)

res <- readRDS("ANCOMBC2_Pathways.rds")

pair <- res$res_pair

write.csv(pair,
          "Results/ANCOMBC2_Pathway_AllPairwise.csv",
          row.names=FALSE)

axilla <- res$res_pair %>%
  filter(diff_isolateAxilla) %>%
  arrange(q_isolateAxilla)

write.csv(
  axilla,
  "Results/ANCOMBC2_Pathways_Axilla_vs_Arm.csv",
  row.names = FALSE
)

scalp <- res$res_pair %>%
  filter(diff_isolateScalp) %>%
  arrange(q_isolateScalp)

write.csv(
  scalp,
  "Results/ANCOMBC2_Pathways_Scalp_vs_Arm.csv",
  row.names = FALSE
)

scalp_axilla <- res$res_pair %>%
  filter(diff_isolateScalp_isolateAxilla) %>%
  arrange(q_isolateScalp_isolateAxilla)

write.csv(
  scalp_axilla,
  "Results/ANCOMBC2_Pathways_Scalp_vs_Axilla.csv",
  row.names = FALSE
)

cat("Axilla vs Arm:", nrow(axilla), "\n")
cat("Scalp vs Arm:", nrow(scalp), "\n")
cat("Scalp vs Axilla:", nrow(scalp_axilla), "\n")

summary(res$res_pair$q_isolateAxilla)

summary(res$res_pair$q_isolateScalp)

summary(res$res_pair$q_isolateScalp_isolateAxilla)

summary(abs(res$res_pair$lfc_isolateAxilla))

summary(abs(res$res_pair$lfc_isolateScalp))

summary(abs(res$res_pair$lfc_isolateScalp_isolateAxilla))
