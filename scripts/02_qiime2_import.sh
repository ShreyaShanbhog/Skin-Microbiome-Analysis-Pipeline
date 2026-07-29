#!/bin/bash

qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path manifest.tsv \
    --output-path demux.qza \
    --input-format SingleEndFastqManifestPhred33V2

qiime demux summarize \
    --i-data demux.qza \
    --o-visualization demux.qzv
