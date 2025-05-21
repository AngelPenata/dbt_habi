import pandas as pd
import psycopg2
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from sklearn.metrics import mean_squared_error, r2_score
import numpy as np
import os

# --- Conexión ---
conn = psycopg2.connect(
    host="redshift-cluster-1.ci27ispoiqnv.us-east-2.redshift.amazonaws.com",
    port="5439",
    database="dev",
    user="awsuser",
    password="VNIFWgwygd655*&"
)
cursor = conn.cursor()

# --- Obtener datos ---
query = """
SELECT area_m2, precio, banios, alcobas, nombre_cliente
FROM dev.dev_habi_prueba_tecnica.propiedades_clientes
"""
df = pd.read_sql(query, conn)

promedio_area = df.groupby(['alcobas', 'banios'])['area_m2'].mean().reset_index()
print("\nPromedio de área por combinación:")
print(promedio_area)

# 2. Preparar datos para el modelo
X = df[['alcobas', 'banios', 'area_m2']]
y = df['precio']

# 3. Entrenar el modelo
model = LinearRegression()
model.fit(X, y)

# 4. Evaluar modelo
y_pred = model.predict(X)
rmse = np.sqrt(mean_squared_error(y, y_pred))
r2 = r2_score(y, y_pred)

print(f"\n--- Modelo entrenado ---")
print(f"Intercepto: {model.intercept_}")
print(f"Coeficientes: {model.coef_}")
print(f"RMSE: {rmse:.2f}")
print(f"R²: {r2:.2f}")

# 5. Agregar columna de precio estimado al DataFrame
df['precio_estimado'] = model.predict(X).round(2)

# 6. Mostrar las primeras filas con el nuevo campo
print("\n--- DataFrame con precios estimados ---")
print(df.head())

r2 = r2_score(y, y_pred)
print(f"R² del modelo: {r2:.4f}")

# --- Guardar CSV en carpeta seeds/ ---
script_dir = os.path.dirname(os.path.abspath(__file__))
seeds_dir = os.path.join(script_dir, 'seeds')
os.makedirs(seeds_dir, exist_ok=True)

csv_path = os.path.join(seeds_dir, 'outliers_propiedades_clientes.csv')

# Borrar si ya existe
if os.path.exists(csv_path):
    os.remove(csv_path)

# Guardar archivo
df.to_csv(csv_path, index=False, encoding='utf-8')

print(f"✅ Archivo CSV generado correctamente en: {csv_path}")