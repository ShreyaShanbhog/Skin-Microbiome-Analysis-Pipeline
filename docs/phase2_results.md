# Skin Microbiome Functional Analysis Pipeline

> Bioinformatics analysis of predicted metabolic differences across anatomical skin sites using 16S rRNA amplicon sequencing and PICRUSt2 functional profiling — with applications to microbiome-based cosmetic formulation.

![Python](https://img.shields.io/badge/Python-3.10+-blue) ![QIIME2](https://img.shields.io/badge/QIIME2-2024.5-teal) ![PICRUSt2](https://img.shields.io/badge/PICRUSt2-2.5-green) ![Status](https://img.shields.io/badge/status-Phase%202%20complete-orange)

---

## Overview

This project characterises the predicted functional potential of skin microbiomes from three anatomically distinct sites — **arm**, **axilla**, and **scalp** — using publicly available 16S rRNA sequencing data. Rather than focusing solely on taxonomic composition, the pipeline emphasises **metabolic pathway prediction** via PICRUSt2, connecting computational findings to real-world cosmetic formulation concepts.

The goal is to ask: *do the predicted microbial functions at different skin sites support or challenge current microbiome-based skincare claims?*

---

## Key findings (Phase 2)

| Skin site | Functional signature | Cosmetic relevance |
|-----------|---------------------|-------------------|
| **Scalp** | Enriched for fatty acid metabolism, lipid degradation, β-oxidation, vitamin B biosynthesis | Supports sebum-regulating formulations; aligns with panthenol and niacinamide use in scalp products |
| **Arm** | Broader biosynthetic repertoire — amino acid, sulfur, lipid biosynthesis | Suggests a functionally diverse community suited to multi-ingredient barrier formulations |
| **Axilla** | Comparatively specialised; fewer enriched pathways | Supports targeted prebiotic/postbiotic approaches over broad-spectrum antimicrobials |

Differential abundance analysis (ANCOM-BC2, FDR q < 0.05) identified:
- **430 significantly different pathways** between axilla and arm
- **427 significantly different pathways** between scalp and arm
- **273 significantly different pathways** between scalp and axilla

---

## Repository structure

```
skin-microbiome-pipeline/
│
├── data/
│   ├── raw/                  # Raw FASTQ files (not tracked — see Data section)
│   └── processed/            # QIIME2 artifacts, trimmed reads, ASV tables
│
├── results/
│   ├── taxonomy/             # Taxonomy bar charts, classifier outputs
│   ├── diversity/            # Alpha/beta diversity metrics, PCoA plots
│   ├── differential/         # ANCOM-BC2 results, volcano plots
│   ├── picrust2/             # Pathway abundance tables, ANCOM-BC2 on pathways
│   └── figures/              # Final publication-quality figures (300 dpi)
│
├── scripts/
│   ├── 01_preprocessing.sh   # Trimming, QIIME2 import, DADA2 denoising
│   ├── 02_taxonomy.sh        # SILVA classification, taxonomy bar charts
│   ├── 03_diversity.py       # Alpha/beta diversity, PCoA, PERMANOVA
│   ├── 04_differential.R     # ANCOM-BC2 differential abundance
│   ├── 05_picrust2.sh        # PICRUSt2 functional prediction pipeline
│   └── 06_pathway_analysis.R # Pathway differential abundance, boxplots
│
├── docs/
│   ├── preprocessing_log.md  # Data quality notes, filtering decisions, DADA2 stats
│   ├── methods.md            # Full methods write-up (paper-style)
│   └── cosmetic_discussion.md # Pathway → ingredient → brand claim mapping
│
├── environment.yml           # Conda environment for full reproducibility
├── requirements.txt          # Python dependencies
└── README.md
```

---

## Methods summary

### Data

Public 16S rRNA amplicon sequencing data from skin microbiome samples across three anatomical sites (arm, axilla, scalp) downloaded from NCBI SRA using the SRA Toolkit.

> Raw data not included in this repository due to file size. See `docs/preprocessing_log.md` for accession numbers and download instructions.

### Pipeline

1. **Quality control** — FastQC for initial QC; Cutadapt for adapter trimming and quality filtering
2. **Denoising** — DADA2 within QIIME2 to generate Amplicon Sequence Variants (ASVs); 96.97% of reads retained after filtering from 18,834 to 1,793 ASVs
3. **Taxonomy** — Assigned using the SILVA 138 classifier within QIIME2
4. **Diversity analysis** — Shannon index, Chao1, observed features (alpha); Bray-Curtis and UniFrac distances + PCoA (beta); PERMANOVA for group significance
5. **Differential abundance** — ANCOM-BC2 in R for taxonomic and pathway-level comparisons
6. **Functional prediction** — PICRUSt2 to infer MetaCyc pathway abundances from 16S data
7. **Pathway analysis** — ANCOM-BC2 on pathway abundance table; boxplot visualisation of top significant pathways per site comparison

> **Important caveat:** PICRUSt2 predicts the *functional potential* of microbial communities from marker gene data — it does not directly measure metabolic activity, gene expression, or metabolite production. All pathway findings should be interpreted as predicted functional capacity.

---

## Pathway → cosmetic ingredient mapping

A key output of Phase 2 is a translational summary connecting computational findings to cosmetic formulation:

| Significant pathway | Biological role | Cosmetic ingredient | Brands | Data support |
|---|---|---|---|---|
| Fatty acid β-oxidation | Sebum utilisation | Niacinamide, Zinc PCA | La Roche-Posay, CeraVe | ✅ Partial |
| Histidine degradation | Acid mantle maintenance | Lactic acid, PHAs | Gallinée | ✅ Partial |
| Lipid biosynthesis | Barrier homeostasis | Panthenol, Ceramides | La Roche-Posay | ✅ Partial |
| Pantothenate biosynthesis | Vitamin B5 production | Panthenol | Haircare broadly | ✅ Partial |
| Functional diversity | Microbial resilience | Inulin, Alpha-glucan oligosaccharide | Gallinée | ✅ Partial |

Full discussion with evidence-graded brand claim evaluation is in [`docs/cosmetic_discussion.md`](docs/cosmetic_discussion.md).

---

## Brand claim evaluation

| Brand | Claim | Evidence level | Data agreement |
|---|---|---|---|
| Gallinée | Supports microbial diversity via prebiotics | ⭐⭐⭐ Expert consensus | Partial — distinct functional profiles observed across sites |
| Gallinée | Maintains acidic skin pH | ⭐⭐ Mechanistic | Partial — histidine/amino acid metabolism differs by site |
| La Roche-Posay | Strengthens skin barrier | ⭐⭐⭐⭐ Clinical (Cicaplast RCT) | Partial — lipid metabolism enriched in scalp microbiome |
| La Roche-Posay | Restores microbiome balance | ⭐ Marketing claim | Cannot evaluate — no disease samples or longitudinal data |
| Mother Dirt | Supports beneficial bacteria | ⭐⭐ Mechanistic | Partial — tissue-specific microbial functions observed |
| Delphi Consensus | Prebiotics/postbiotics improve microbiome | ⭐⭐⭐ Expert consensus | General agreement — functional differences support site-specific modulation |

---

## Reproducing this analysis

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/skin-microbiome-pipeline.git
cd skin-microbiome-pipeline
```

### 2. Set up the environment

```bash
conda env create -f environment.yml
conda activate skin-microbiome
```

### 3. Download raw data

Follow instructions in `docs/preprocessing_log.md` to download FASTQ files from NCBI SRA into `data/raw/`.

### 4. Run the pipeline

```bash
bash scripts/01_preprocessing.sh
bash scripts/02_taxonomy.sh
python scripts/03_diversity.py
Rscript scripts/04_differential.R
bash scripts/05_picrust2.sh
Rscript scripts/06_pathway_analysis.R
```

---

## Limitations

- PICRUSt2 predicts functional potential from 16S data, not measured gene expression or metabolite production
- Only healthy skin microbiomes were analysed — disease-associated dysbiosis and treatment effects cannot be evaluated
- No host transcriptomic, metabolomic, or clinical outcome data available for validation
- Predicted pathways represent community-level capacity, not individual species activity
- Future work integrating shotgun metagenomics, metatranscriptomics, or metabolomics would directly confirm these predicted functions

---

## Roadmap

- [x] Phase 1 — Data acquisition, preprocessing, taxonomy assignment
- [x] Phase 2 — Diversity analysis, differential abundance, PICRUSt2 functional profiling
- [ ] Phase 3 — Machine learning classification of skin sites from microbiome profiles
- [ ] Phase 3 — Microbial co-occurrence network analysis
- [ ] Phase 4 — Full written report, portfolio presentation, LinkedIn posts

---

## Author

**[Your Name]**
MSc Bioinformatics | Skin microbiome researcher
Interested in computational approaches to cosmetic science and microbiome-targeted formulation.

[LinkedIn](#) · [Portfolio](#) · [Email](#)

---

## License

MIT License — see `LICENSE` for details.
