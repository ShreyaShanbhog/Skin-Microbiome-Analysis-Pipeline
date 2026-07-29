# ==============================================================================
# 0. LIBRARIES & DEPENDENCIES
# ==============================================================================
library(phyloseq)
library(tidyverse)
library(ANCOMBC)
library(ggrepel)
library(scales)

# ==============================================================================
# 1. OTU / FEATURE TABLE PREPARATION
# ==============================================================================
otu_raw <- read_tsv("feature-table.tsv")

otu_mat <- otu_raw %>%
  column_to_rownames("Feature_ID") %>%
  as.matrix()

mode(otu_mat) <- "numeric"

# Ensure taxa are formatted as rows
if (nrow(otu_mat) < ncol(otu_mat)) {
  otu_mat <- t(otu_mat)
}

otu <- otu_table(otu_mat, taxa_are_rows = TRUE)

# ==============================================================================
# 2. METADATA PREPARATION
# ==============================================================================
meta <- read_tsv("metadata.tsv") %>%
  column_to_rownames("sample-id")

meta <- sample_data(meta)

# ==============================================================================
# 3. TAXONOMY CLEANING & RANK SPLITTING
# ==============================================================================
tax_raw <- read_tsv("taxonomy.tsv")

# Clean standard prefixes (e.g., "g__")
tax_df <- tax_raw %>%
  transmute(
    taxon = `Feature ID`,
    Taxon = Taxon
  ) %>%
  mutate(
    Taxon = gsub("^[a-z]__", "", Taxon)
  )

# Split taxonomy string into distinct rank columns
tax_mat <- tax_df %>%
  separate(
    Taxon,
    into = paste0("Rank", 1:7),
    sep = ";\\s*",
    fill = "right"
  ) %>%
  column_to_rownames("taxon")

tax <- tax_table(as.matrix(tax_mat))

# ==============================================================================
# 4. BUILD PHYLOSEQ OBJECT
# ==============================================================================
ps <- phyloseq(otu, tax, meta)

# ==============================================================================
# 5. ANCOM-BC2 DIFFERENTIAL ABUNDANCE (ASV LEVEL)
# ==============================================================================
res <- ancombc2(
  data = ps,
  fix_formula = "isolate",
  group = "isolate",
  p_adj_method = "fdr",
  pairwise = TRUE,
  alpha = 0.05
)

# Extract results dataframe
res_pair <- as.data.frame(res$res_pair)

# Map original taxonomy strings back to results
res_pair_annot <- res_pair %>%
  left_join(tax_df, by = "taxon") %>%
  left_join(rownames_to_column(as.data.frame(tax_mat), "taxon"), by = "taxon")

# ==============================================================================
# 6. FILTER & EXPORT SIGNIFICANT TAXA
# ==============================================================================
# Filter any taxon that is robustly significant in at least one contrast
sig_taxa <- res_pair_annot %>%
  filter(
    diff_robust_isolateAxilla == TRUE |
      diff_robust_isolateScalp == TRUE |
      diff_robust_isolateScalp_isolateAxilla == TRUE
  ) %>%
  rename(
    Phylum = Rank2,
    Family = Rank5,
    Genus  = Rank6
  )

write.csv(sig_taxa, "significant_taxa_annotated.csv", row.names = FALSE)

# Split and export specific contrasts
sig_axilla_vs_arm <- res_pair_annot %>% filter(diff_robust_isolateAxilla == TRUE)
sig_scalp_vs_arm  <- res_pair_annot %>% filter(diff_robust_isolateScalp == TRUE)
sig_scalp_vs_axilla <- res_pair_annot %>% filter(diff_robust_isolateScalp_isolateAxilla == TRUE)

write.csv(sig_axilla_vs_arm, "ANCOMBC2_Axilla_vs_Arm.csv", row.names = FALSE)
write.csv(sig_scalp_vs_arm, "ANCOMBC2_Scalp_vs_Arm.csv", row.names = FALSE)
write.csv(sig_scalp_vs_axilla, "ANCOMBC2_Scalp_vs_Axilla.csv", row.names = FALSE)

# ==============================================================================
# 7. DATA VISUALIZATION: VOLCANO PLOT
# ==============================================================================
volcano_df <- res_pair_annot %>%
  mutate(
    neglog10p = -log10(p_isolateAxilla),
    sig = diff_robust_isolateAxilla
  )

ggplot(volcano_df, aes(x = lfc_isolateAxilla, y = neglog10p)) +
  geom_point(aes(color = sig), alpha = 0.7, size = 2) +
  scale_color_manual(values = c("grey70", "#D62728")) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed") +
  theme_classic(base_size = 14) +
  labs(
    x = "Log Fold Change (Axilla vs Arm)",
    y = "-log10(p-value)",
    title = "ANCOM-BC2 Differential Abundance"
  ) +
  theme(legend.position = "none")

# ==============================================================================
# 8. GENUS-LEVEL COLLAPSE & ANCOM-BC2
# ==============================================================================
ps_genus <- tax_glom(ps, taxrank = "Rank6")

res_genus <- ancombc2(
  data = ps_genus,
  fix_formula = "isolate",
  group = "isolate",
  p_adj_method = "fdr",
  pairwise = TRUE,
  alpha = 0.05
)

# ==============================================================================
# 9. DATA VISUALIZATION: RELATIVE ABUNDANCE BAR PLOT
# ==============================================================================
# Transform to relative abundance and glom by Genus
ps_rel <- transform_sample_counts(ps, function(x) x / sum(x))
ps_genus_bar <- tax_glom(ps_rel, taxrank = "Rank6")

df_bar <- psmelt(ps_genus_bar) %>%
  mutate(Genus = ifelse(is.na(Rank6), "Unknown", Rank6))

# Identify top 15 most abundant genera to avoid a cluttered legend
top_genus <- df_bar %>%
  group_by(Genus) %>%
  summarise(total = sum(Abundance)) %>%
  arrange(desc(total)) %>%
  head(15) %>%
  pull(Genus)

# Group lower abundance taxa into "Other"
df_bar_final <- df_bar %>%
  mutate(Genus = ifelse(Genus %in% top_genus, Genus, "Other"))

# Plot
ggplot(df_bar_final, aes(x = isolate, y = Abundance, fill = Genus)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  theme_classic(base_size = 14) +
  labs(
    x = "Body Site",
    y = "Relative Abundance"
  )
