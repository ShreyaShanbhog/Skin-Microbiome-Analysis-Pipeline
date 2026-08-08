# ==========================================================
# Logistic Regression Classification of Skin Microbiome
# Compare with Random Forest
# ==========================================================

import pandas as pd
import numpy as np

from sklearn.model_selection import (
    train_test_split,
    StratifiedKFold,
    cross_val_score,
    GridSearchCV
)

from sklearn.preprocessing import StandardScaler

from sklearn.pipeline import Pipeline

from sklearn.linear_model import LogisticRegression

from sklearn.metrics import (
    accuracy_score,
    classification_report,
    confusion_matrix,
    roc_auc_score
)

from sklearn.preprocessing import label_binarize


# ==========================================================
# 1. LOAD DATA
# ==========================================================

df = pd.read_csv(
    "skin_microbiome_ml_dataset.csv",
    index_col=0
)

print("=" * 60)
print("DATASET")
print("=" * 60)

print("Shape:", df.shape)


# ==========================================================
# 2. CREATE X AND y
# ==========================================================

# Target = skin site
y = df["isolate"]

# Remove target + metadata
X = df.drop(
    columns=[
        "isolate",
        "ethnicity",
        "sex",
        "tissue"
    ],
    errors="ignore"
)

# Keep only numeric ASV abundance features
X = X.select_dtypes(
    include=["number"]
)

print("\nFeature matrix:", X.shape)

print("\nClasses:")
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

print("\nTraining samples:", X_train.shape[0])

print("Testing samples:", X_test.shape[0])


# ==========================================================
# 4. CREATE LOGISTIC REGRESSION PIPELINE
# ==========================================================

logistic_pipeline = Pipeline([

    (
        "scaler",
        StandardScaler()
    ),

    (
        "logistic",
        LogisticRegression(
            max_iter=5000,
            random_state=42
        )
    )
])


# ==========================================================
# 5. TUNE LOGISTIC REGRESSION
# ==========================================================

param_grid = {

    "logistic__C": [
        0.001,
        0.01,
        0.1,
        1,
        10,
        100
    ],

    "logistic__penalty": [
        "l2"
    ]

}


grid = GridSearchCV(

    estimator=logistic_pipeline,

    param_grid=param_grid,

    cv=5,

    scoring="accuracy",

    n_jobs=-1,

    verbose=1

)


print("\nRunning Logistic Regression tuning...\n")

grid.fit(
    X_train,
    y_train
)


# ==========================================================
# 6. BEST MODEL
# ==========================================================

best_lr = grid.best_estimator_

print("\nBest Logistic Regression Parameters:")

print(grid.best_params_)

print("\nBest CV Accuracy:")

print(grid.best_score_)


# ==========================================================
# 7. TEST SET PREDICTIONS
# ==========================================================

y_pred = best_lr.predict(
    X_test
)


# ==========================================================
# 8. TEST ACCURACY
# ==========================================================

accuracy = accuracy_score(

    y_test,

    y_pred

)

print("\nTest Accuracy:")

print(f"{accuracy:.3f}")


# ==========================================================
# 9. CLASSIFICATION REPORT
# ==========================================================

print("\nClassification Report:")

print(
    classification_report(
        y_test,
        y_pred
    )
)


# ==========================================================
# 10. CROSS-VALIDATION
# ==========================================================

cv = StratifiedKFold(

    n_splits=5,

    shuffle=True,

    random_state=42

)

cv_scores = cross_val_score(

    best_lr,

    X,

    y,

    cv=cv,

    scoring="accuracy",

    n_jobs=-1

)

print("\n5-Fold Cross Validation:")

print(cv_scores)

print(
    f"\nMean CV Accuracy: "
    f"{cv_scores.mean():.3f}"
)

print(
    f"CV Standard Deviation: "
    f"{cv_scores.std():.3f}"
)


# ==========================================================
# 11. MULTICLASS ROC-AUC
# ==========================================================

y_prob = best_lr.predict_proba(
    X_test
)

classes = best_lr.classes_

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

print(
    f"\nMacro ROC-AUC: {auc:.3f}"
)


# ==========================================================
# 12. SUMMARY
# ==========================================================

print("\n" + "=" * 60)

print("LOGISTIC REGRESSION SUMMARY")

print("=" * 60)

print(
    f"Test Accuracy: "
    f"{accuracy:.3f}"
)

print(
    f"Mean CV Accuracy: "
    f"{cv_scores.mean():.3f}"
)

print(
    f"CV SD: "
    f"{cv_scores.std():.3f}"
)

print(
    f"Macro ROC-AUC: "
    f"{auc:.3f}"
)

print("=" * 60)
