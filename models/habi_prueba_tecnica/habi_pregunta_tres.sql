{{
    config(
        materialized = "table",
        alias = 'pregunta_tres',
        tags = ["habi"]
    )
}}

 

SELECT
    ciudad,
    precio_venta,
    fecha_creacion
FROM  "dev"."dev_habi_prueba_tecnica"."inmuebles"
where precio_venta > (
    SELECT AVG(precio_venta)
from  "dev"."dev_habi_prueba_tecnica"."inmuebles"
where publicado_por = 'Carolina Castro Jaramillo'
)
