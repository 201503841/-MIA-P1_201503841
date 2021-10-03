-- CONSULTA 1
SELECT
    TIENDA.NOMBRE,
    CANTIDAD
FROM
    TIENDA,
    INVENTARIO,
    PELICULA
WHERE
    ID_TIENDA = TIENDA_ID_TIENDA
    AND ID_PELICULA = PELICULA_ID_PELICULA
    AND PELICULA.TITULO = 'SUGAR WONKA'
UNION
SELECT
    'TOTAL',
    SUM(CANTIDAD)
FROM
    INVENTARIO,
    PELICULA
WHERE
    ID_PELICULA = PELICULA_ID_PELICULA
    AND PELICULA.TITULO = 'SUGAR WONKA'
ORDER BY
    cantidad;

--CONSULTA 2
SELECT
    CLIENTE.NOMBRE,
    CLIENTE.APELLIDO,
    SUM(RENTA.MONTO) AS MONTO
FROM
    RENTA,
    CLIENTE
WHERE
    RENTA.CLIENTE_ID_CLIENTE = ID_CLIENTE
GROUP BY
    CLIENTE.NOMBRE,
    CLIENTE.APELLIDO
HAVING
    COUNT(*) >= 40;

-- CONSULTA 3
SELECT
    NOMBRE || ' ' || APELLIDO AS NOMBRE_COMPLETO
FROM
    CLIENTE
WHERE
    LOWER(APELLIDO) LIKE '%son%'
ORDER BY
    NOMBRE ASC;

-- CONSULTA 4
SELECT
    DISTINCT NOMBRE,
    APELLIDO,
    ANO_LANZAMIENTO
FROM
    ACTOR_PELICULA AP,
    ACTOR A,
    PELICULA P
WHERE
    DESCRIPCION LIKE '%Crocodile%'
    AND DESCRIPCION LIKE '%Shark%'
    AND AP.ID_ACTOR = A.ID_ACTOR
    AND AP.ID_PELICULA = P.ID_PELICULA
ORDER BY
    APELLIDO ASC;

-- CONSULTA 5
SELECT
    MD.NOMBRE AS PAIS,
    MD.CLIENTE,
    (MD.CANTIDAD * 100) / MP.CANTIDAD_PAIS AS PROMEDIO
FROM
    PAIS,
    CIUDAD,
    CLIENTE,
    (
        SELECT
            P.ID_PAIS,
            P.NOMBRE,
            C.ID_CLIENTE,
            C.NOMBRE AS CLIENTE,
            COUNT(*) AS CANTIDAD
        FROM
            CLIENTE C,
            RENTA R,
            CIUDAD CI,
            PAIS P
        WHERE
            C.ID_CLIENTE = R.CLIENTE_ID_CLIENTE
            AND CI.ID_CIUDAD = C.CIUDAD_ID_CIUDAD
            AND CI.PAIS_ID_PAIS = P.ID_PAIS
        GROUP BY
            P.ID_PAIS,
            P.NOMBRE,
            C.ID_CLIENTE,
            C.NOMBRE
        ORDER BY
            CANTIDAD DESC
        LIMIT
            1
    ) MD, (
        SELECT
            ID_PAIS,
            PAIS.NOMBRE,
            COUNT(*) AS CANTIDAD_PAIS
        FROM
            PAIS,
            CIUDAD,
            CLIENTE,
            RENTA
        WHERE
            PAIS.ID_PAIS = CIUDAD.PAIS_ID_PAIS
            AND CLIENTE.CIUDAD_ID_CIUDAD = CIUDAD.ID_CIUDAD
            AND CLIENTE.ID_CLIENTE = RENTA.CLIENTE_ID_CLIENTE
        GROUP BY
            ID_PAIS,
            PAIS.NOMBRE
    ) MP
WHERE
    PAIS.ID_PAIS = CIUDAD.PAIS_ID_PAIS
    AND CIUDAD.ID_CIUDAD = CLIENTE.CIUDAD_ID_CIUDAD
    AND MD.ID_PAIS = PAIS.ID_PAIS
    AND MP.ID_PAIS = PAIS.ID_PAIS;

-- CONSULTA 6
SELECT
    TOTAL_PAIS.PAIS,
    TOTAL_CIUDAD.CIUDAD,
    TOTAL_CIUDAD.TOTAL,
    TRUNC(
        (TOTAL_CIUDAD.TOTAL :: decimal * 100) / TOTAL_PAIS.TOTAL,
        2
    ) || '%' AS PORCENTAJE
FROM
    (
        SELECT
            PAIS.NOMBRE AS PAIS,
            CIUDAD.NOMBRE AS CIUDAD,
            count(*) AS TOTAL
        FROM
            PAIS,
            CIUDAD,
            CLIENTE
        WHERE
            PAIS.ID_PAIS = CIUDAD.PAIS_ID_PAIS
            AND CIUDAD.ID_CIUDAD = CLIENTE.CIUDAD_ID_CIUDAD
        GROUP BY
            PAIS.NOMBRE,
            CIUDAD.NOMBRE
    ) TOTAL_CIUDAD,
    (
        SELECT
            PAIS.NOMBRE AS PAIS,
            count(*) AS TOTAL
        FROM
            PAIS,
            CIUDAD,
            CLIENTE
        WHERE
            PAIS.ID_PAIS = CIUDAD.PAIS_ID_PAIS
            AND CIUDAD.ID_CIUDAD = CLIENTE.CIUDAD_ID_CIUDAD
        GROUP BY
            PAIS.NOMBRE
    ) TOTAL_PAIS
WHERE
    TOTAL_CIUDAD.PAIS = TOTAL_PAIS.PAIS
ORDER BY
    TOTAL_CIUDAD.PAIS;

-- CONSULTA 7
SELECT
    RENTAS_PP.PAIS,
    CIUDAD,
    TRUNC(
        (
            (RENTAS_PC.RENTAS :: decimal / RENTASTOTAL) * 100
        ),
        2
    ) AS PORCENTAJE
FROM
    (
        SELECT
            PAIS.NOMBRE AS PAIS,
            COUNT(*) AS RENTASTOTAL
        FROM
            PAIS,
            CIUDAD,
            CLIENTE,
            RENTA
        WHERE
            PAIS.ID_PAIS = CIUDAD.PAIS_ID_PAIS
            AND CIUDAD.ID_CIUDAD = CLIENTE.CIUDAD_ID_CIUDAD
            AND RENTA.CLIENTE_ID_CLIENTE = CLIENTE.ID_CLIENTE
        GROUP BY
            PAIS.NOMBRE
        ORDER BY
            PAIS.NOMBRE
    ) RENTAS_PP,
    (
        SELECT
            PAIS.NOMBRE AS PAIS,
            CIUDAD.NOMBRE AS CIUDAD,
            COUNT(*) AS RENTAS
        FROM
            PAIS,
            CIUDAD,
            CLIENTE,
            RENTA
        WHERE
            PAIS.ID_PAIS = CIUDAD.PAIS_ID_PAIS
            AND CIUDAD.ID_CIUDAD = CLIENTE.CIUDAD_ID_CIUDAD
            AND RENTA.CLIENTE_ID_CLIENTE = CLIENTE.ID_CLIENTE
        GROUP BY
            PAIS.NOMBRE,
            CIUDAD.NOMBRE
        ORDER BY
            PAIS.NOMBRE
    ) RENTAS_PC
WHERE
    RENTAS_PP.PAIS = RENTAS_PC.PAIS;

-- CONSULTA 8
SELECT
    RENTAS_PAIS_CAT_SPORT.PAIS AS PAIS,
    TRUNC(
        (RENTAS_PAIS_CAT_SPORT.RENTAS :: DECIMAL) / RENTAS_TOTALES_PAIS.RENTAS * 100,
        2
    ) AS PORCENTAJE
FROM
    (
        SELECT
            CATEGORIA.NOMBRE AS CATEGORIA,
            PAIS.NOMBRE AS PAIS,
            COUNT(*) AS RENTAS
        FROM
            PAIS,
            CIUDAD,
            CLIENTE,
            RENTA,
            PELICULA,
            CATEGORIA_PELICULA,
            CATEGORIA
        WHERE
            PAIS.ID_PAIS = CIUDAD.PAIS_ID_PAIS
            AND CIUDAD.ID_CIUDAD = CLIENTE.CIUDAD_ID_CIUDAD
            AND RENTA.CLIENTE_ID_CLIENTE = CLIENTE.ID_CLIENTE
            AND RENTA.PELICULA_ID_PELICULA = PELICULA.ID_PELICULA
            AND PELICULA.ID_PELICULA = CATEGORIA_PELICULA.ID_PELICULA
            AND CATEGORIA.ID_CATEGORIA = CATEGORIA_PELICULA.ID_CATEGORIA
            AND CATEGORIA.NOMBRE = 'Sports'
        GROUP BY
            CATEGORIA.NOMBRE,
            PAIS.NOMBRE
    ) RENTAS_PAIS_CAT_SPORT,
    (
        SELECT
            PAIS.NOMBRE AS PAIS,
            COUNT(*) AS RENTAS
        FROM
            PAIS,
            CIUDAD,
            CLIENTE,
            RENTA
        WHERE
            PAIS.ID_PAIS = CIUDAD.PAIS_ID_PAIS
            AND CIUDAD.ID_CIUDAD = CLIENTE.CIUDAD_ID_CIUDAD
            AND RENTA.CLIENTE_ID_CLIENTE = CLIENTE.ID_CLIENTE
        GROUP BY
            PAIS.NOMBRE
    ) RENTAS_TOTALES_PAIS
WHERE
    RENTAS_PAIS_CAT_SPORT.PAIS = RENTAS_TOTALES_PAIS.PAIS;

-- CONSULTA 9
SELECT
    CIUDAD.NOMBRE AS CIUDAD,
    COUNT(*) AS RENTAS
FROM
    PAIS,
    CIUDAD,
    CLIENTE,
    RENTA
WHERE
    PAIS.ID_PAIS = CIUDAD.PAIS_ID_PAIS
    AND CIUDAD.ID_CIUDAD = CLIENTE.CIUDAD_ID_CIUDAD
    AND RENTA.CLIENTE_ID_CLIENTE = CLIENTE.ID_CLIENTE
    AND PAIS.NOMBRE = 'United States'
GROUP BY
    PAIS.NOMBRE,
    CIUDAD.NOMBRE
HAVING
    COUNT(*) > (
        SELECT
            COUNT(*)
        FROM
            CIUDAD,
            CLIENTE,
            RENTA
        WHERE
            CIUDAD.ID_CIUDAD = CLIENTE.CIUDAD_ID_CIUDAD
            AND RENTA.CLIENTE_ID_CLIENTE = CLIENTE.ID_CLIENTE
            AND CIUDAD.NOMBRE = 'Dayton'
        GROUP BY
            CIUDAD.NOMBRE
    );

-- CONSULTA 10
SELECT
    RENTAS_PC.PAIS,
    RENTAS_PC.CIUDAD,
    RENTAS_PC.NUMERO_RENTAS
FROM
    (
        SELECT
            PAIS,
            CIUDAD,
            MAX(RENTAS) As NUMERO_RENTAS
        FROM
            (
                SELECT
                    CATEGORIA.NOMBRE AS CATEGORIA,
                    PAIS.NOMBRE AS PAIS,
                    CIUDAD.NOMBRE AS CIUDAD,
                    COUNT(*) AS RENTAS
                FROM
                    PAIS,
                    CIUDAD,
                    CLIENTE,
                    RENTA,
                    PELICULA,
                    CATEGORIA_PELICULA,
                    CATEGORIA
                WHERE
                    PAIS.ID_PAIS = CIUDAD.PAIS_ID_PAIS
                    AND CIUDAD.ID_CIUDAD = CLIENTE.CIUDAD_ID_CIUDAD
                    AND RENTA.CLIENTE_ID_CLIENTE = CLIENTE.ID_CLIENTE
                    AND RENTA.PELICULA_ID_PELICULA = PELICULA.ID_PELICULA
                    AND PELICULA.ID_PELICULA = CATEGORIA_PELICULA.ID_PELICULA
                    AND CATEGORIA.ID_CATEGORIA = CATEGORIA_PELICULA.ID_CATEGORIA
                GROUP BY
                    CATEGORIA.NOMBRE,
                    PAIS.NOMBRE,
                    CIUDAD.NOMBRE
            ) TEMP
        GROUP BY
            PAIS,
            CIUDAD
        ORDER BY
            PAIS,
            CIUDAD
    ) RENTAS_PC,
    (
        SELECT
            CATEGORIA.NOMBRE AS CATEGORIA,
            PAIS.NOMBRE AS PAIS,
            CIUDAD.NOMBRE AS CIUDAD,
            COUNT(*) AS RENTAS
        FROM
            PAIS,
            CIUDAD,
            CLIENTE,
            RENTA,
            PELICULA,
            CATEGORIA_PELICULA,
            CATEGORIA
        WHERE
            PAIS.ID_PAIS = CIUDAD.PAIS_ID_PAIS
            AND CIUDAD.ID_CIUDAD = CLIENTE.CIUDAD_ID_CIUDAD
            AND RENTA.CLIENTE_ID_CLIENTE = CLIENTE.ID_CLIENTE
            AND RENTA.PELICULA_ID_PELICULA = PELICULA.ID_PELICULA
            AND PELICULA.ID_PELICULA = CATEGORIA_PELICULA.ID_PELICULA
            AND CATEGORIA.ID_CATEGORIA = CATEGORIA_PELICULA.ID_CATEGORIA
        GROUP BY
            CATEGORIA.NOMBRE,
            PAIS.NOMBRE,
            CIUDAD.NOMBRE
    ) POR_CAT
WHERE
    RENTAS_PC.PAIS = POR_CAT.PAIS
    AND RENTAS_PC.CIUDAD = POR_CAT.CIUDAD
    AND RENTAS_PC.NUMERO_RENTAS = POR_CAT.RENTAS
    AND CATEGORIA = 'Horror';