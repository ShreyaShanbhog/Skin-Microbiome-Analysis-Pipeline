#!/bin/bash

qiime feature-classifier classify-sklearn \
    --i-classifier silva-138-99-nb-classifier.qza \
    --i-reads rep-seqs.qza \
    --o-classification taxonomy.qza

qiime metadata tabulate \
    --m-input-file taxonomy.qza \
    --o-visualization taxonomy.qzv

qiime tools export \
    --input-path taxonomy.qza \
    --output-path taxonomy_export
