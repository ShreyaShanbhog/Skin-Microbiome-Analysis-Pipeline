# Skin Microbiome Analysis Pipeline

[![Bioinformatics](https://img.shields.io/badge/Domain-Bioinformatics-blue.svg)](https://en.wikipedia.org/wiki/Bioinformatics)
[![R&D Skincare](https://img.shields.io/badge/Industry-Cosmetic%20R%26D-purple.svg)](https://en.wikipedia.org/wiki/Cosmeceutical)
[![Pipeline](https://img.shields.io/badge/Pipeline-DADA2%20%7C%20QIIME2-orange.svg)]()

## Project Overview
The skincare industry is undergoing a massive shift toward microbiome-focused formulations (probiotics, prebiotics, and postbiotics). However, translating marketing claims into cutting-edge R&D requires robust data science. 

This repository contains a complete, end-to-end bioinformatics pipeline designed to analyze publicly available skin microbiome datasets from NCBI’s Sequence Read Archive (SRA). The pipeline processes raw 16S rRNA sequencing data to identify, quantify, and compare microbial communities across different skin phenotypes (e.g., Acne-prone vs. Healthy, Dry vs. Oily). By determining specific microbial signatures, this tool bridges the gap between raw biological data and targeted, evidence-based cosmetic formulation.

---

## Key Features
* **Automated Data Fetching:** Directly pulls targeted skin microbiome fastq datasets using NCBI SRA Toolkit.
* **16S rRNA Quality Control & Processing:** End-to-end processing using DADA2/QIIME2 to clean, denoise, and filter reads into Exact Sequence Variants (ASVs).
* **Taxonomic Classification:** Assigns identities down to the genus/species level using specialized skin-microbiome reference databases (SILVA/Greengenes).
* **Comparative Statistical Analytics:** * **Alpha Diversity:** Measures richness and evenness within individual skin types (e.g., Shannon Index).
  * **Beta Diversity:** Uncovers microbial composition shifts *between* healthy and compromised skin states (PCoA plots using UniFrac distances).
  * **Differential Abundance:** Pinpoints exact biomarkers (e.g., shifts in *Cutibacterium acnes* vs. *Staphylococcus epidermidis* ratios) to inform product development.

---

## Repository Structure
```text
├── data/
├── scripts/
├── results/
├── docs/
└── README.md
