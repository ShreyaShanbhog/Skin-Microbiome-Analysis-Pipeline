# Skin Microbiome Analysis Pipeline

A microbiome analysis pipeline built using publicly available skin microbiome sequencing data from NCBI SRA. The project aims to identify microbial composition patterns across skin sites and explore implications for skincare and cosmetic product development.

---

## Dataset

| Field | Detail |
|---|---|
| **BioProject** | PRJNA314604 |
| **Study** | Human skin microbiome |
| **Samples** | 642 skin swab samples |
| **Sequencing Platform** | Illumina MiSeq |
| **Read Type** | Single-end amplicon sequencing (16S rRNA) |

**Sample Metadata Available:**
- Age
- Sex
- Ethnicity
- Skin site (Scalp, Axilla, Arm, etc.)

---

## Repository Structure

```
skin-microbiome/
├── README.md
├── manifest.csv
├── metadata.tsv
├── .gitignore
├── scripts/
├── results/
├── fastqc/
├── multiqc_report.html
├── multiqc_data/
├── demux.qza
├── demux.qzv
├── table.qza
├── table-summary.qzv
├── rep-seqs.qza
├── denoising-stats.qza
├── denoising-stats.qzv
└── docs/
    └── preprocessing_log.md
```
---

## Pipeline Progress

| Stage | Status |
|---|---|
| Quality Control (FastQC / MultiQC) | Complete |
| QIIME2 Import | Complete |
| DADA2 Denoising | Complete |
| Taxonomic Classification (SILVA) | Complete |
| Alpha / Beta Diversity | Complete |
| Differential Abundance | Complete |
| Functional Prediction (PICRUSt2) | Complete |
| ML Classification | Next |

---

## Phase 1

### Quality Control

FastQC and MultiQC were used to assess raw sequencing quality across all 642 samples.

**Observations:**
- High per-base sequence quality across all samples
- No adapter contamination detected
- Some GC-content deviations observed
- Overrepresented sequences present (expected for amplicon data)
- Sequence duplication levels consistent with amplicon sequencing

---

### QIIME2 Import

Sequences were imported into QIIME2 using `SingleEndFastqManifestPhred33V2` format.

```bash
qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path manifest.tsv \
  --output-path demux.qza \
  --input-format SingleEndFastqManifestPhred33V2

qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv
```

---

### DADA2 Denoising

Reads were denoised and error-corrected using DADA2.

**Parameters:**

| Parameter | Value |
|---|---|
| `--p-trim-left` | 0 |
| `--p-trunc-len` | 250 |

```bash
qiime dada2 denoise-single \
  --i-demultiplexed-seqs demux.qza \
  --p-trunc-len 250 \
  --p-trim-left 0 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza \
  --o-base-transition-stats base-transition-stats.qza

qiime metadata tabulate \
  --m-input-file denoising-stats.qza \
  --o-visualization denoising-stats.qzv

qiime feature-table summarize \
  --i-table table.qza \
  --o-feature-frequencies feature-frequencies.qza \
  --o-sample-frequencies sample-frequencies.qza \
  --o-summary table-summary.qzv
```

---

## Key Results

### DADA2 Read Retention (Example Sample)

| Stage | Reads |
|---|---|
| Input | 6,944 |
| Filtered | 6,827 |
| Denoised | 6,777 |
| Non-chimeric | 6,777 |

**Per-sample retention: ~97.6%**

**Overall pipeline retention (642 samples):**

| Metric | Reads |
|---|---|
| Total Input | 11,040,199 |
| Total Retained | 10,392,640 |
| **Retention Rate** | **94.1%** |

---

### Feature Table Summary

| Metric | Value |
|---|---|
| Samples | 642 |
| Unique ASVs | 18,834 |
| Total Reads | 10,392,640 |
| Minimum Reads/Sample | 3,136 |
| Median Reads/Sample | 14,826 |
| Mean Reads/Sample | 16,188 |
| Maximum Reads/Sample | 86,117 |

---
## Phase 2 – Functional Prediction Using PICRUSt2

### Objective
Predict the functional potential of the skin microbiome using 16S rRNA sequencing data.

### Methods
- Filtered ASVs by prevalence (≥5 samples)
- Retained 1,793 ASVs (96.97% of sequencing reads)
- Predicted KEGG pathways using PICRUSt2
- Performed differential pathway abundance analysis using ANCOM-BC2
- Visualized significant pathways using boxplots

### Key Results
- 430 significant pathways (Axilla vs Arm)
- 427 significant pathways (Scalp vs Arm)
- 273 significant pathways (Scalp vs Axilla)

Major pathway categories:
- Lipid metabolism
- Fatty acid metabolism
- Amino acid metabolism
- Vitamin biosynthesis
- Sulfur metabolism

### Biological Findings
- Scalp microbiome enriched for lipid metabolism pathways.
- Arm microbiome displayed broader biosynthetic potential.
- Axillary microbiome exhibited greater functional specialization.

### Cosmetic Relevance
The predicted microbial functions support tissue-specific microbiome skincare strategies using prebiotics, postbiotics, and barrier-supportive ingredients.

---

## Requirements

- [QIIME2](https://qiime2.org/) (2023.x+)
- FastQC
- MultiQC
- Python 3.8+

---

## Citation

If referencing this dataset:

> Bouslimani A, et al. (2016). Molecular cartography of the human skin surface in 3D. *PNAS*. BioProject: PRJNA314604.
