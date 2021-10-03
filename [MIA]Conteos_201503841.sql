SELECT
    'pais',
    COUNT(*)
FROM
    pais
UNION
SELECT
    'clasificacion',
    COUNT(*)
FROM
    clasificacion
UNION
SELECT
    'categoria',
    COUNT(*)
FROM
    categoria
UNION
SELECT
    'actor',
    COUNT(*)
FROM
    actor
UNION
SELECT
    'idioma',
    COUNT(*)
FROM
    idioma
UNION
SELECT
    'ciudad',
    COUNT(*)
FROM
    ciudad
UNION
SELECT
    'tienda',
    COUNT(*)
FROM
    tienda
UNION
SELECT
    'empleado',
    COUNT(*)
FROM
    empleado
UNION
SELECT
    'cliente',
    COUNT(*)
FROM
    cliente
UNION
SELECT
    'pelicula',
    COUNT(*)
FROM
    pelicula
UNION
SELECT
    'renta',
    COUNT(*)
FROM
    renta
UNION
SELECT
    'inventario',
    COUNT(*)
FROM
    inventario
UNION
SELECT
    'categoria_pelicula',
    COUNT(*)
FROM
    categoria_pelicula
UNION
SELECT
    'actor_pelicula',
    COUNT(*)
FROM
    actor_pelicula
UNION
SELECT
    'lenguaje_pelicula',
    COUNT(*)
FROM
    lenguaje_pelicula