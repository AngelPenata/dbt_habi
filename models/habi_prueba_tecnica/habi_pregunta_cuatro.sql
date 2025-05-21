{{
    config(
        materialized = "table",
        alias = 'pregunta_cuatro',
        tags = ["habi"]
    )
}}


with tamano_promedio_precio as (
select   
    tamano,
    AVG(precio_venta) AS promedio_precio_venta
FROM "dev"."dev_habi_prueba_tecnica"."inmuebles"
where 
    n_habitaciones >= 3
    AND n_banos >= 2
group by 1
)
select     
    tamano,
    promedio_precio_venta
from tamano_promedio_precio
where promedio_precio_venta > 80000000
order by promedio_precio_venta desc
LIMIT 20 