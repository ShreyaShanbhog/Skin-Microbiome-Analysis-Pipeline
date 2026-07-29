# =========================
# 0. LIBRARIES
# =========================

library(phyloseq)
library(tidyverse)
library(readr)

# =========================
# 1. READ PATHWAY TABLE
# =========================

pathways <- read_tsv("path_abun_unstrat.tsv.gz")

# First column = pathway IDs
path_mat <- pathways %>%
  column_to_rownames("pathway") %>%
  as.matrix()

OTU <- otu_table(path_mat, taxa_are_rows = TRUE)

# =========================
# 2. READ METADATA
# =========================

meta <- read_tsv("metadata.tsv") %>%
  column_to_rownames("sample-id")

META <- sample_data(meta)

# =========================
# 3. BUILD PHYLOSEQ
# =========================

ps_path <- phyloseq(
  OTU,
  META
)

# Check sample order
sample_names(ps_path)[1:5]
rownames(meta)[1:5]

# Save object
saveRDS(ps_path, "pathway_phyloseq.rds")

cat("\nPhyloseq object created successfully.\n")
