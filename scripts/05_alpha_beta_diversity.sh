#!/bin/bash

qiime diversity core-metrics-phylogenetic \
    --i-phylogeny rooted-tree.qza \
    --i-table table.qza \
    --p-sampling-depth 3000 \
    --m-metadata-file metadata.tsv \
    --output-dir core-metrics-results

#PERMANOVA
qiime diversity beta-group-significance \
    --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza \
    --m-metadata-file metadata.tsv \
    --m-metadata-column isolate \
    --p-method permanova \
    --o-visualization bray-isolate-permanova.qzv
