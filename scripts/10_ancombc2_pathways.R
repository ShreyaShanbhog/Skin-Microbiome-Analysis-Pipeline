library(phyloseq)
library(ANCOMBC)
library(tidyverse)

ps <- readRDS("pathway_phyloseq.rds")

res <- ancombc2(
  
  data = ps,
  
  fix_formula = "isolate",
  
  p_adj_method = "fdr",
  
  prv_cut = 0.10,
  
  lib_cut = 1000,
  
  group = "isolate",
  
  pairwise = TRUE,
  
  alpha = 0.05
  
)

saveRDS(res,"ANCOMBC2_Pathways.rds")
