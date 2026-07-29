#!/bin/bash

qiime dada2 denoise-single \
    --i-demultiplexed-seqs demux.qza \
    --p-trunc-len 250 \
    --p-trim-left 0 \
    --o-table table.qza \
    --o-representative-sequences rep-seqs.qza \
    --o-denoising-stats stats.qza \
    --p-n-threads 8

qiime metadata tabulate \
    --m-input-file stats.qza \
    --o-visualization stats.qzv

qiime feature-table summarize \
    --i-table table.qza \
    --o-visualization table-summary.qzv \
    --m-sample-metadata-file metadata.tsv
