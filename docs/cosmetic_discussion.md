# Cosmetic implications: connecting computational findings to microbiome-based skincare

This document maps the significant metabolic pathways identified in this analysis to cosmetic ingredients, brand formulation claims, and the level of evidence supporting each connection.

> All findings derive from PICRUSt2-predicted functional potential, not measured metabolic activity. Conclusions are framed as hypotheses consistent with the data, not causal claims.

---

## Evidence grading framework

Rather than treating all claims equally, this analysis grades cosmetic evidence by study type:

| Grade | Evidence type | Example |
|---|---|---|
| ⭐⭐⭐⭐ | Randomised clinical trial | La Roche-Posay Cicaplast, Sphingomonas ferment RCT |
| ⭐⭐⭐ | Expert consensus or systematic review | Delphi consensus on microbiome-friendly cosmetics |
| ⭐⭐ | Mechanistic or in vitro data | Tight junction proteins, kallikrein inhibition studies |
| ⭐ | Marketing or brand website claim | Gallinée, Mother Dirt, OmNutra websites |

---

## Claim-by-claim evaluation

### 1. "Supports microbial diversity"

**Brands making this claim:** Gallinée, Trilogy, Delphi Consensus

**What the data show:**
Different skin sites exhibit distinct predicted metabolic capabilities — the arm harbours a broader biosynthetic repertoire, the scalp specialises in lipid metabolism, and the axilla shows a comparatively narrow functional profile.

**Interpretation:**
The observed differences in predicted metabolic pathways across anatomical sites support the concept that preserving microbial diversity may help maintain tissue-specific microbial functions. However, functional diversity was inferred indirectly — diversity was not measured directly in this dataset.

**Discussion wording:**
> "The observed differences in predicted metabolic pathways across anatomical sites support the concept that preserving microbial diversity may help maintain tissue-specific microbial functions."

---

### 2. "Restores microbiome balance"

**Brands making this claim:** La Roche-Posay, Dove, Eucerin, OmNutra

**What the data show:**
This claim cannot be evaluated with the present dataset. PICRUSt2 predicts gene content, not healthy versus dysbiotic microbiome states. No disease samples or longitudinal treatment data were included.

**Discussion wording:**
> "This claim cannot be directly evaluated using the present dataset because no disease samples or longitudinal treatment data were analysed."

**Note:** Stating this limitation honestly strengthens the report — it demonstrates scientific rigour over overclaiming.

---

### 3. "Strengthens skin barrier"

**Brands making this claim:** La Roche-Posay, Biphole; supported by Cicaplast RCT (⭐⭐⭐⭐)

**What the data show:**
The scalp microbiome is enriched for fatty acid metabolism, lipid biosynthesis, and stearate biosynthesis — pathways associated with membrane synthesis, lipid turnover, and indirectly with barrier homeostasis.

**Discussion wording:**
> "Our results partially support this claim by identifying enrichment of lipid metabolic pathways that may contribute indirectly to maintaining the skin barrier."

**Key qualifier:** *may contribute* — not *proves*.

---

### 4. "Supports acidic skin pH"

**Brands making this claim:** OmNutra, Gallinée

**What the data show:**
Histidine degradation, arginine metabolism, and sulfur amino acid metabolism all differ significantly across skin sites. These pathways influence acidic metabolite production and contribute to the skin acid mantle.

**Interpretation:**
This is one of the stronger connections in the dataset. The data are consistent with the role of microbial amino acid metabolism in maintaining skin acidity.

---

### 5. "Prebiotics feed beneficial bacteria"

**Brands making this claim:** Gallinée, Delphi Consensus (⭐⭐⭐)

**What the data show:**
Different skin sites possess different predicted metabolic functions and therefore different microbial nutritional requirements.

**Novel interpretation:**
Rather than one prebiotic benefiting all skin sites uniformly, these data suggest that prebiotic selection should be **site-specific**. The scalp's lipid-metabolising community has different nutritional requirements than the arm's biosynthetically diverse community.

> "Different skin sites exhibit distinct microbial functional profiles, suggesting that prebiotic formulations may need to be tailored to the metabolic requirements of site-specific microbial communities rather than adopting a universal approach."

---

### 6. "Postbiotics reduce inflammation"

**Brands making this claim:** Gallinée, La Roche-Posay

**What the data show:**
No inflammatory markers, cytokines, or host response data were available in this analysis.

**Discussion:** Cannot evaluate. Acknowledge as a limitation and note this as a direction for future metatranscriptomic or metabolomic work.

---

### 7. "Sebum regulation"

**Brands making this claim:** Niacinamide and zinc-based scalp products broadly

**What the data show:**
This is the **strongest connection** in the dataset. The scalp microbiome is enriched for fatty acid degradation, lipid metabolism, β-oxidation, and lipid salvage — exactly the functional profile expected in a sebum-rich environment.

**Interpretation:**
Products that *regulate* rather than *remove* sebum are most consistent with supporting the lipid-metabolising microbial communities found on the scalp.

> "Enrichment of fatty acid metabolic pathways within the scalp microbiome suggests that formulations designed to preserve beneficial lipid-utilising microorganisms — rather than aggressively removing sebum — may better support microbial homeostasis."

---

## Pathway → ingredient → brand mapping

| Significant pathway | Biological role | Cosmetic ingredient | Brands | Data support |
|---|---|---|---|---|
| Fatty acid β-oxidation | Sebum utilisation | Niacinamide, Zinc PCA | La Roche-Posay, CeraVe | ✅ Partial |
| Histidine degradation | Acid mantle maintenance | Lactic acid, PHAs | Gallinée | ✅ Partial |
| Lipid biosynthesis | Barrier homeostasis | Panthenol, Ceramides | La Roche-Posay | ✅ Partial |
| Pantothenate biosynthesis | Vitamin B5 production | Panthenol, Biotin | Haircare broadly | ✅ Partial |
| Functional diversity (arm) | Microbial resilience | Inulin, Alpha-glucan oligosaccharide | Gallinée | ✅ Partial |
| Lipid metabolism (scalp) | Sebaceous adaptation | Sphingomonas ferment extract | La Roche-Posay | ✅ Partial |
| Axillary specialisation | Odour-associated community | Zinc ricinoleate, Lactobacillus ferment lysate | Odour care brands | ✅ Partial |

---

## Suggested conclusion paragraph

> The present study provides functional evidence supporting several microbiome-based skincare concepts currently used in cosmetic formulations. Predicted enrichment of lipid metabolism pathways within the scalp microbiome is consistent with formulations designed to maintain healthy sebaceous microbial communities rather than aggressively removing surface lipids. Likewise, differences in amino acid metabolism across skin sites support the concept that microbiome-targeted formulations should be adapted to the unique physiological environment of each anatomical location. However, because PICRUSt2 predicts functional potential rather than directly measuring microbial activity or clinical outcomes, claims regarding restoration of microbiome balance, reduction of inflammation, or improvement of skin health cannot be directly validated by the present analysis.

---

## Limitations of this comparison

1. PICRUSt2 predicts gene content from 16S marker gene data — it does not measure pathway activity, gene expression, or metabolite production
2. No disease samples were included, so claims about restoring balance in dysbiotic skin cannot be evaluated
3. Brand claims vary widely in their own evidence base — a claim backed by an RCT and a claim on a product website are treated differently in this analysis
4. The cosmetic ingredient connections represent biologically plausible hypotheses, not demonstrated mechanisms
