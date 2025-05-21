{{
    config(
        materialized = "table",
        alias = 'out_propiedades_clientes',
        tags = ["habi"]
    )
}}

with out_propiedades_clientes as (
    SELECT
    area_m2,	
    precio,	
    banios,	
    alcobas,	
    nombre_cliente,	
    ROUND(precio_estimado, 0) as precio_estimado
FROM
    "dev"."dev_dbt_seeds"."outliers_propiedades_clientes")
SELECT
    area_m2,	
    precio,	
    banios,	
    alcobas,	
    nombre_cliente,	
    precio_estimado,
    ROUND(((precio /precio_estimado)-1)::float, 2) AS ratio,
    CASE
        WHEN ratio = 0 THEN 'Precio igual al estimado'
        WHEN ratio > 0 AND ratio <= 0.10 THEN 'Precio algo elevado'
        WHEN ratio > 0.10 AND ratio <= 0.20 THEN 'Precio elevado'
        WHEN ratio > 0.20 THEN 'Precio muy elevado'
        WHEN ratio < 0 AND ratio >= -0.10 THEN 'Precio algo bajo'
        WHEN ratio < -0.10 AND ratio >= -0.20 THEN 'Precio bajo'
        WHEN ratio < -0.20 THEN 'Precio muy bajo'
    end as clasificacion_cliente
from out_propiedades_clientes