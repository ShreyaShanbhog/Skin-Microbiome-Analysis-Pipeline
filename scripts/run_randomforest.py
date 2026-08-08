# ==========================================================
# Random Forest Classification of Skin Microbiome Samples
# ==========================================================

import pandas as pd
import matplotlib.pyplot as plt

from sklearn.model_selection import (
    train_test_split,
    RandomizedSearchCV,
    cross_val_score
)

from sklearn.ensemble import RandomForestClassifier

from sklearn.metrics import (
    accuracy_score,
    classification_report,
    confusion_matrix,
    ConfusionMatrixDisplay,
    roc_auc_score
)

from sklearn.preprocessing import label_binarize

# ==========================================================
# 1. LOAD DATA
# ==========================================================

df = pd.read_csv("skin_microbiome_ml_dataset.csv", index_col=0)

print("=" * 60)
print("Dataset Loaded")
print(df.shape)
print("=" * 60)

# ==========================================================
# 2. CREATE FEATURES (X) AND LABELS (y)
# ==========================================================

y = df["isolate"]

X = df.drop(columns=[
    "isolate",
    "ethnicity",
    "sex",
    "tissue"
], errors="ignore")

print("\nFeature Matrix Shape:", X.shape)
print("Classes:")
print(y.value_counts())

# ==========================================================
# 3. TRAIN / TEST SPLIT
# ==========================================================

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    stratify=y,
    random_state=42
)

print("\nTraining Samples:", X_train.shape[0])
print("Testing Samples:", X_test.shape[0])

# ==========================================================
# 4. RANDOM FOREST HYPERPARAMETER TUNING
# ==========================================================

param_dist = {

    "n_estimators": [100, 200, 300, 500],

    "max_depth": [
        None,
        10,
        20,
        30
    ],

    "min_samples_split": [
        2,
        5,
        10
    ],

    "min_samples_leaf": [
        1,
        2,
        4
    ],

    "max_features": [
        "sqrt",
        "log2"
    ]
}

rf = RandomForestClassifier(random_state=42)

random_search = RandomizedSearchCV(

    estimator=rf,

    param_distributions=param_dist,

    n_iter=30,

    cv=5,

    scoring="accuracy",

    random_state=42,

    n_jobs=-1,

    verbose=2

)

print("\nRunning Randomized Search...\n")

random_search.fit(X_train, y_train)

best_rf = random_search.best_estimator_

print("\nBest Parameters:")
print(random_search.best_params_)

print("\nBest Cross Validation Accuracy:")
print(random_search.best_score_)

# ==========================================================
# 5. CROSS VALIDATION
# ==========================================================

scores = cross_val_score(

    best_rf,

    X,

    y,

    cv=5,

    scoring="accuracy",

    n_jobs=-1

)

print("\nCross Validation Scores")

print(scores)

print(f"\nMean Accuracy = {scores.mean():.3f}")

print(f"Standard Deviation = {scores.std():.3f}")

# ==========================================================
# 6. PREDICTION
# ==========================================================

best_rf.fit(X_train, y_train)

y_pred = best_rf.predict(X_test)

# ==========================================================
# 7. ACCURACY
# ==========================================================

accuracy = accuracy_score(y_test, y_pred)

print("\nTest Accuracy")

print(accuracy)

# ==========================================================
# 8. CLASSIFICATION REPORT
# ==========================================================

print("\nClassification Report")

print(classification_report(y_test, y_pred))

# ==========================================================
# 9. CONFUSION MATRIX
# ==========================================================

cm = confusion_matrix(y_test, y_pred)

disp = ConfusionMatrixDisplay(

    confusion_matrix=cm,

    display_labels=best_rf.classes_

)

disp.plot(cmap="Blues")

plt.title("Random Forest Confusion Matrix")

plt.tight_layout()

plt.savefig("confusion_matrix.png", dpi=300)

plt.show()

# ==========================================================
# 10. FEATURE IMPORTANCE
# ==========================================================

importance = pd.DataFrame({

    "ASV": X.columns,

    "Importance": best_rf.feature_importances_

})

importance = importance.sort_values(

    by="Importance",

    ascending=False

)

print("\nTop 20 Important ASVs")

print(importance.head(20))

importance.to_csv(

    "feature_importance.csv",

    index=False

)

# ==========================================================
# 11. TOP 20 FEATURE IMPORTANCE PLOT
# ==========================================================

top20 = importance.head(20)

plt.figure(figsize=(10,8))

plt.barh(

    top20["ASV"],

    top20["Importance"]

)

plt.gca().invert_yaxis()

plt.xlabel("Importance")

plt.title("Top 20 Most Important ASVs")

plt.tight_layout()

plt.savefig(

    "top20_feature_importance.png",

    dpi=300

)

plt.show()

# ==========================================================
# 12. MULTICLASS ROC AUC
# ==========================================================

y_prob = best_rf.predict_proba(X_test)

classes = best_rf.classes_

y_test_bin = label_binarize(

    y_test,

    classes=classes

)

auc = roc_auc_score(

    y_test_bin,

    y_prob,

    multi_class="ovr",

    average="macro"

)

print(f"\nMacro ROC-AUC = {auc:.3f}")

# ==========================================================
# 13. MERGE FEATURE IMPORTANCE WITH TAXONOMY
# ==========================================================

taxonomy = pd.read_csv(

    "taxonomy.tsv",

    sep="\t"

)

importance_tax = importance.merge(

    taxonomy,

    left_on="ASV",

    right_on="Feature_ID",

    how="left"

)

importance_tax.drop(

    columns=["Feature_ID"],

    inplace=True,

    errors="ignore"

)

importance_tax.to_csv(

    "feature_importance_with_taxonomy.csv",

    index=False

)

print("\nTop 20 Features with Taxonomy")

print(importance_tax.head(20))

print("\nAnalysis Complete!")
