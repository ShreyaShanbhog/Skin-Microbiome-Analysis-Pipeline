#!/bin/bash

qiime tools export \
    --input-path table.qza \
    --output-path exported-feature-table

biom convert \
    -i exported-feature-table/feature-table.biom \
    -o feature-table.tsv \
    --to-tsv

qiime tools export \
    --input-path taxonomy.qza \
    --output-path taxonomy_export
