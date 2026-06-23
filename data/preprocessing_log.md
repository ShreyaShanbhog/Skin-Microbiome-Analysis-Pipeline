# Preprocessing Log

## Dataset

| Field | Detail |
|---|---|
| **BioProject** | PRJNA314604 |
| **Samples** | 642 |
| **Platform** | Illumina MiSeq |
| **Read Type** | Single-end 16S amplicon |

---

## Quality Control

**Tools used:**
- FastQC
- MultiQC

**Observations:**
- High per-base sequence quality across all samples
- No adapter contamination detected
- Some GC-content deviations observed (acceptable for skin microbiome amplicon data)
- Overrepresented sequences detected (expected for 16S amplicon; primers/conserved regions)
- Sequence duplication levels consistent with amplicon sequencing

**Decision:** No trimming of adapters required. DADA2 quality filtering handles low-quality tails.

---

## QIIME2 Import

**Format:** `SingleEndFastqManifestPhred33V2`

**Input:** `manifest.tsv` (sample-id → absolute-filepath mapping)

**Output:**
- `demux.qza` — imported sequences artifact
- `demux.qzv` — demux summary visualization

**Command:**
```bash
qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path manifest.tsv \
  --output-path demux.qza \
  --input-format SingleEndFastqManifestPhred33V2
```

---

## DADA2 Denoising

**Tool:** QIIME2 `dada2 denoise-single`

**Parameters:**

| Parameter | Value | Rationale |
|---|---|---|
| `--p-trim-left` | 0 | No primer contamination detected in QC |
| `--p-trunc-len` | 250 | Maintains quality while maximising read length |

**Outputs:**
- `table.qza` — ASV feature table
- `rep-seqs.qza` — representative sequences
- `denoising-stats.qza` — per-sample read tracking

**Commands:**
```bash
qiime dada2 denoise-single \
  --i-demultiplexed-seqs demux.qza \
  --p-trunc-len 250 \
  --p-trim-left 0 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza \
  --o-base-transition-stats base-transition-stats.qza
```

---

## Results Summary

### Read Retention

| Stage | Reads |
|---|---|
| Input Reads | 11,040,199 |
| Retained Reads | 10,392,640 |
| **Retention Rate** | **94.1%** |

### Feature Table

| Metric | Value |
|---|---|
| Samples | 642 |
| Unique ASVs | 18,834 |
| Total Reads | 10,392,640 |
| Min Reads/Sample | 3,136 |
| Median Reads/Sample | 14,826 |
| Mean Reads/Sample | 16,188 |
| Max Reads/Sample | 86,117 |

---

## Notes

- All 642 samples passed filtering — no samples dropped below minimum depth threshold.
- High ASV count (18,834) reflects diversity across multiple distinct skin sites.
- Denoising stats visualized in `denoising-stats.qzv`; feature table summarized in `table-summary.qzv`.
- Minimum reads/sample (3,136) should be revisited when setting rarefaction depth for alpha diversity.

---

## Date Completed

Week 1–2 milestone: QC → Import → DADA2 complete.
