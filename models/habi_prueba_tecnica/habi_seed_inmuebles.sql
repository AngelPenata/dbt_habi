{{
    config(
        materialized = "table",
        alias = 'inmuebles',
        tags = ["habi"]
    )
}}

SELECT
    ciudad,	
    zona,
    direccion,
    tamano,	
    "nº de baños" as n_banos,
    "nº de habitaciones" as n_habitaciones,
    "precio de venta" as precio_venta,
    "fecha de creacion" as fecha_creacion,
    "publicado por" as publicado_por
FROM
    "dev"."dev_dbt_seeds"."inmuebles"