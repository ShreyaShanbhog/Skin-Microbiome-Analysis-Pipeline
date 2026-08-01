# ============================================
# Prepare QIIME2 Feature Table for Machine Learning
# ============================================

import pandas as pd

# -------------------------------
# 1. Load feature table
# -------------------------------
otu = pd.read_csv(
    "feature-table.tsv",
    sep="\t"
)

print("Original feature table:")
print(otu.head())
print("\nShape:", otu.shape)

# -------------------------------
# 2. Set ASV IDs as the index
# -------------------------------
otu = otu.set_index("Feature_ID")

# -------------------------------
# 3. Transpose the table
# Rows = samples
# Columns = ASVs
# -------------------------------
otu = otu.T

print("\nTransposed feature table:")
print(otu.head())
print("\nShape:", otu.shape)

# -------------------------------
# 4. Load sample metadata
# -------------------------------
meta = pd.read_csv(
    "metadata.tsv",
    sep="\t"
)

print("\nMetadata:")
print(meta.head())

# -------------------------------
# 5. Set sample IDs as the index
# -------------------------------
meta = meta.set_index("sample-id")

# -------------------------------
# 6. Merge abundance table with metadata
# -------------------------------
df = otu.join(meta)

print("\nMerged dataset:")
print(df.head())
print("\nShape:", df.shape)

# -------------------------------
# 7. Check for missing values
# -------------------------------
print("\nMissing values in each column:")
print(df.isnull().sum())

# -------------------------------
# 8. Save the ML-ready dataset
# -------------------------------
df.to_csv("skin_microbiome_ml_dataset.csv")

print("\nDataset saved as: skin_microbiome_ml_dataset.csv")
