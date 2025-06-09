import pandas as pd
import numpy as np
import pickle
import shap
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split

# 1. Generate dummy data
np.random.seed(42)
n_samples = 1000
df = pd.DataFrame({
    'Amount': np.random.uniform(10, 10000, n_samples),
    'TransactionType': np.random.choice([0, 1], size=n_samples),  # 0 = debit, 1 = credit
    'UnusualLocation': np.random.choice([0, 1], size=n_samples),
    'UnusualAmount': np.random.choice([0, 1], size=n_samples),
    'NewDevice': np.random.choice([0, 1], size=n_samples),
    'FailedAttempts': np.random.randint(0, 5, size=n_samples),
    'FraudFlag': np.random.choice([0, 1], size=n_samples, p=[0.9, 0.1])  # mostly non-fraud
})

# 2. Prepare features and labels
X = df.drop('FraudFlag', axis=1)
y = df['FraudFlag']

# 3. Train model
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
model = RandomForestClassifier()
model.fit(X_train, y_train)

# 4. Save model
with open('./models/fraud_model.pkl', 'wb') as f:
    pickle.dump(model, f)

# 5. Create and save SHAP explainer
explainer = shap.Explainer(model, X_train)
with open('./models/shap_explainer.pkl', 'wb') as f:
    pickle.dump(explainer, f)

print("✅ fraud_model.pkl and shap_explainer.pkl saved successfully.")
