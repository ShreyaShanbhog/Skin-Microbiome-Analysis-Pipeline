library(phyloseq)
library(tidyverse)
library(vegan)
library(pheatmap)

ps <- readRDS("pathway_phyloseq.rds")

# Relative abundance
ps.rel <- transform_sample_counts(ps, function(x) x/sum(x))

# PCA
ord <- ordinate(ps.rel, method = "PCoA", distance = "bray")

pdf("Results/PCoA_Pathways.pdf", width=7, height=6)

plot_ordination(ps.rel,
                ord,
                color="isolate") +
  geom_point(size=3)

dev.off()

# Heatmap

mat <- otu_table(ps.rel)

vars <- apply(mat,1,var)

top <- names(sort(vars,decreasing=TRUE))[1:50]

pdf("Results/Top50_Pathway_Heatmap.pdf",8,10)

pheatmap(as.matrix(mat[top,]),
         scale="row")

dev.off()