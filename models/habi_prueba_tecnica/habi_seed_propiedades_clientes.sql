{{
    config(
        materialized = "table",
        alias = 'propiedades_clientes',
        tags = ["habi"]
    )
}}

select  
area_m2,
precio,	
banios,
alcobas,
latitud,
longitud,	
COALESCE(nombre_cliente,'Sin informacion') as nombre_cliente
from "dev"."dev_dbt_seeds"."base_prueba_bi_mid" as habi_propiedades_clientes