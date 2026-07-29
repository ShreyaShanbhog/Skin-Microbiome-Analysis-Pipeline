# Skin Microbiome Analysis Pipeline

A reproducible bioinformatics pipeline for analyzing the human skin microbiome using 16S rRNA sequencing data. This project integrates microbial taxonomic profiling, diversity analysis, differential abundance testing, and functional prediction to investigate how microbial communities differ across skin sites and how these differences may inform microbiome-based skincare product development.

---

# Project Highlights

- 🧬 Analyzed **642 human skin microbiome samples**
- 🦠 Processed **18,834 ASVs** using DADA2
- 🔬 Assigned taxonomy using the SILVA database
- 📊 Compared microbial communities across **Arm, Axilla, and Scalp**
- ⚙️ Predicted **496 microbial metabolic pathways** using PICRUSt2
- 📈 Identified hundreds of significantly different pathways using ANCOM-BC2
- 💄 Connected microbial functions with published microbiome skincare technologies and cosmetic ingredients

---

# Dataset

| Field | Value |
|------|------|
| BioProject | PRJNA314604 |
| Publication | Bouslimani et al., PNAS (2016) |
| Samples | 642 |
| Sample type | Human skin swabs |
| Sequencing | Illumina MiSeq |
| Read type | Single-end 16S rRNA amplicon |

Metadata included:

- Skin site
- Age
- Sex
- Ethnicity

---

# Workflow

```
Raw FASTQ
      │
      ▼
FastQC + MultiQC
      │
      ▼
QIIME2 Import
      │
      ▼
DADA2 Denoising
      │
      ▼
Taxonomic Assignment (SILVA)
      │
      ▼
Alpha & Beta Diversity
      │
      ▼
Differential Abundance (ANCOM-BC2)
      │
      ▼
PICRUSt2 Functional Prediction
      │
      ▼
Differential Pathway Analysis
      │
      ▼
Biological Interpretation
      │
      ▼
Cosmetic Applications
```

---

# Repository Structure

```
Skin-Microbiome-Analysis-Pipeline/

├── README.md
├── data/
│   ├── metadata.tsv
│   ├── manifest.tsv
|   ├── taxonomy.tsv
│   └── preprocessing_log.md
│
├── scripts/
│   ├── 01_fastqc_multiqc.sh
│   ├── 02_qiime2_import.sh
│   ├── 03_dada2_denoise.sh
│   ├── 04_taxonomy_assignment.sh
│   ├── 05_alpha_beta_diversity.sh
│   ├── 06_export_qiime_tables.sh
│   ├── 07_picrust2_pipeline.sh
│   ├── 08_import_pathways.R
│   ├── 09_exploratory_analysis.R
│   ├── 10_ancombc2_pathways.R
│   ├── 11_annotate_pathways.R
│   ├── 12_pathways.R
│   ├── 13_export_results.R
|   └── 14_ancombc2.R 
│
├── results/
│   ├── differential_abundance/
|   ├── diversity/
|   ├── taxonomy/
│   └── functional_prediction/
│
├── docs/
|   ├── lit_review/
|   ├── methods/
|   ├── abundance-plot.pdf/
│   └── figures/
│
├── multiqc_report.html
├── fastqc_stats.tsv
└── .gitignore
```

---

# Software

| Software | Version |
|-----------|---------|
| QIIME2 | 2026.4 |
| PICRUSt2 | 2.6.2 |
| DADA2 | QIIME2 plugin |
| SILVA | v138 |
| R | 4.x |
| phyloseq | Bioconductor |
| ANCOMBC2 | Bioconductor |

---

# Phase 1 – Taxonomic Analysis

## Quality Control

Raw sequencing reads were assessed using FastQC and summarized with MultiQC.

Quality assessment showed:

- High per-base sequence quality
- No adapter contamination
- Expected sequence duplication for amplicon sequencing
- Minor GC-content variation across samples

---

## DADA2 Denoising

Reads were denoised using DADA2 to remove sequencing errors and infer Amplicon Sequence Variants (ASVs).

### Parameters

| Parameter | Value |
|-----------|------|
| trim-left | 0 |
| trunc-len | 250 |

---

## Read Retention

Example sample

| Stage | Reads |
|------|------:|
| Input | 6,944 |
| Filtered | 6,827 |
| Denoised | 6,777 |
| Non-chimeric | 6,777 |

Overall dataset

| Metric | Value |
|------|------:|
| Total reads | 11,040,199 |
| Retained reads | 10,392,640 |
| Retention | 94.1% |

---

## Feature Table

| Metric | Value |
|------|------:|
| Samples | 642 |
| ASVs | 18,834 |
| Total Reads | 10,392,640 |
| Median Reads/Sample | 14,826 |

---

## Diversity Analysis

Community diversity was evaluated using QIIME2.

Analyses included:

- Shannon diversity
- Bray-Curtis dissimilarity
- Principal Coordinate Analysis (PCoA)
- PERMANOVA

These analyses demonstrated clear differences in microbial community composition across skin sites.

---

## Differential Taxonomic Abundance

Differential abundance testing was performed using ANCOM-BC2.

Pairwise comparisons:

- Arm vs Axilla
- Arm vs Scalp
- Axilla vs Scalp

Results are available in:

```
results/differential_abundance/
```

---

# Phase 2 – Functional Prediction

## PICRUSt2

Functional prediction was performed using PICRUSt2.

### Filtering

| Step | Value |
|------|------:|
| Initial ASVs | 18,834 |
| Filtered ASVs | 1,793 |
| Reads retained | 96.97% |

PICRUSt2 predicted **496 MetaCyc metabolic pathways**.

---

## Differential Functional Analysis

Predicted pathways were analyzed using ANCOM-BC2.

Significant pathways identified:

| Comparison | Significant pathways |
|-----------|---------------------:|
| Axilla vs Arm | 430 |
| Scalp vs Arm | 427 |
| Scalp vs Axilla | 273 |

---

## Major Functional Categories

Differential pathways were primarily involved in:

- Lipid metabolism
- Fatty acid metabolism
- Amino acid metabolism
- Vitamin biosynthesis
- Sulfur metabolism
- Cell wall biosynthesis
- Energy metabolism

---

# Biological Interpretation

Distinct skin sites exhibited different predicted microbial functions.

### Scalp

- Increased lipid and fatty acid metabolism
- Greater biosynthetic activity
- Consistent with a lipid-rich sebaceous environment

### Axilla

- Specialized metabolic pathways
- Enhanced amino acid metabolism
- Functional adaptation to moist skin conditions

### Arm

- Broader biosynthetic potential
- Higher abundance of several vitamin and cofactor biosynthesis pathways
- More metabolically diverse predicted community

---

# Cosmetic Relevance

The functional predictions support several microbiome-targeted skincare strategies.

Observed pathways were consistent with mechanisms involving:

- Lipid metabolism
- Barrier maintenance
- Amino acid metabolism
- Microbial community stability

These findings align with ingredients commonly used in microbiome-focused formulations, including:

- Prebiotics
- Postbiotics
- Fermented extracts
- Thermal spring water
- Barrier-supportive lipids
- Probiotic lysates

Published products from companies such as La Roche-Posay, Gallinée, Mother Dirt, and others report similar microbiome-supportive mechanisms, although evidence strength varies between marketing claims and controlled clinical studies.

---

# Results

Key output files include:

```
results/

ANCOMBC2_Axilla_vs_Arm.csv

ANCOMBC2_Scalp_vs_Arm.csv

ANCOMBC2_Scalp_vs_Axilla.csv

Skin_Pathway_Table_AllSamples.csv

significant_taxa_annotated.csv
```

Figures include:

- Volcano plots
- Pathway abundance boxplots
- Diversity analyses

---

# Future Work

- Machine learning classification of skin sites
- Integration with shotgun metagenomic datasets
- Validation using experimentally measured metagenomes
- Host–microbiome interaction analysis
- Cosmetic ingredient prioritization using functional predictions

---

# Citation

If you use this repository, please cite:

> Bouslimani A. et al. Molecular cartography of the human skin surface in 3D. *Proceedings of the National Academy of Sciences*. 2016.

---

# License

This project is intended for research and educational purposes.
