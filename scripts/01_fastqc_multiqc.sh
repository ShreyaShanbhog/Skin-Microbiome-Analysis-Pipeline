#!/bin/bash

mkdir -p fastqc

fastqc *.fastq.gz \
    -o fastqc \
    -t 8

multiqc fastqc \
    -o .
