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
| Taxonomic Classification (SILVA) | Next |
| Alpha / Beta Diversity | Planned |
| Differential Abundance | Planned |
| Functional Prediction (PICRUSt2) | Planned |
| ML Classification | Planned |

---

## Week 1–2: Data Processing

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

## Results

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

## Preliminary Interpretation

- Sequencing depth is adequate for downstream diversity analyses across all 642 samples.
- DADA2 retained 94.1% of reads after quality filtering and chimera removal.
- 18,834 unique ASVs indicate substantial microbial diversity across sampled skin sites.
- Skin-site metadata enables future comparisons of microbial community composition across body locations (scalp, axilla, arm, etc.).

---

## Next Steps

1. **Taxonomic classification** — assign taxonomy using the SILVA 16S rRNA database
2. **Taxonomy barplots** — visualize community composition per sample/site
3. **Alpha diversity** — Shannon index, observed features, Faith's PD
4. **Beta diversity** — Bray-Curtis, UniFrac (requires phylogenetic tree)
5. **PERMANOVA testing** — test significance of skin-site and metadata groupings
6. **Differential abundance analysis** — identify taxa enriched at specific skin sites
7. **Functional prediction** — PICRUSt2 for pathway-level insights
8. **Machine learning classification** — classify samples by skin site or metadata

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
