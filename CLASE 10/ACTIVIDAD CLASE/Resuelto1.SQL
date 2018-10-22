-- PRIMERA PARTE DE LA CLASE
--------------------------------
-- Por cada tipo de propiedad, la cantidad de vecinos 
-- distintos que poseen propiedades de dicho tipo.
SELECT TP.TIPO,COUNT(DISTINCT P.DNI) AS CANTIDAD
FROM TIPOS_PROPIEDADES AS TP
INNER JOIN PROPIEDADES AS P ON P.IDTIPO = TP.ID
GROUP BY TP.TIPO

-- Por cada tipo de propiedad, la cantidad de vecinos 
-- que poseen propiedades de dicho tipo.
SELECT TP.TIPO,COUNT(P.DNI) AS CANTIDAD
FROM TIPOS_PROPIEDADES AS TP
LEFT JOIN PROPIEDADES AS P ON P.IDTIPO = TP.ID
GROUP BY TP.TIPO

-- Listar apellido y nombres de los vecinos que tengan más de 
-- una propiedad sin superficie construida (superficie construida 
-- igual a cero)
SELECT V.APELLIDOS, V.NOMBRES
FROM VECINOS AS V
INNER JOIN PROPIEDADES AS P ON P.DNI = V.DNI
WHERE P.SUPERFICIE_CONSTRUIDA = 0
GROUP BY V.APELLIDOS, V.NOMBRES
HAVING COUNT(*) > 1

-- Listar apellido y nombres de los vecinos que tengan alguna propiedad 
-- con superficie construida y ninguna propiedad sin superficie 
-- construida
SELECT TABLITA.APELLIDOS, TABLITA.NOMBRES FROM (
SELECT V.APELLIDOS, V.NOMBRES, 
	(SELECT COUNT(*) FROM PROPIEDADES WHERE DNI=V.DNI AND SUPERFICIE_CONSTRUIDA > 0) AS CANT_CON, 
	(SELECT COUNT(*) FROM PROPIEDADES WHERE DNI=V.DNI AND SUPERFICIE_CONSTRUIDA = 0) AS CANT_SIN
FROM VECINOS AS V
) AS TABLITA
WHERE TABLITA.CANT_CON > 0 AND TABLITA.CANT_SIN = 0

-- Listar el vecino que disponga de la casa con mayor valor por m2.
SELECT TOP 1 V.APELLIDOS, V.NOMBRES, P.VALOR, P.SUPERFICIE, P.VALOR/P.SUPERFICIE AS VALORM2
FROM VECINOS AS V
INNER JOIN PROPIEDADES AS P ON P.DNI = V.DNI
INNER JOIN TIPOS_PROPIEDADES AS TP ON TP.ID = P.IDTIPO
WHERE TP.TIPO = 'CASA'
ORDER BY P.VALOR/P.SUPERFICIE DESC

-- Para cada vecino, listar apellido y nombre y la antigüedad menor 
-- de sus propiedades. Si un vecino no tiene
-- propiedades registradas, listar una antigüedad con valor NULL.
SELECT V.APELLIDOS, V.NOMBRES, MIN(P.ANTIGUEDAD) AS VALORMIN
FROM VECINOS AS V
LEFT JOIN PROPIEDADES AS P ON V.DNI = P.DNI
GROUP BY V.APELLIDOS, V.NOMBRES

-- A todos los vecinos cuya sumatoria de valuación de todas sus 
-- propiedades sea mayor a $4.000.000 y posean más de una propiedad se
-- le aplicará un impuesto del 5% del valor de sus propiedades 
-- (a excepción del valor de su propiedad más cara). 
-- Listar apellido y nombre de los vecinos que deban pagar el impuesto 
-- y cuánto deberán pagar.
SELECT AUX.APELLIDOS, AUX.NOMBRES, (AUX.SUMA-AUX.MAS_CARA)*0.05 AS IMPUESTO FROM (
SELECT V.APELLIDOS, V.NOMBRES,
	(SELECT SUM(VALOR) FROM PROPIEDADES WHERE DNI = V.DNI) AS SUMA,
	(SELECT COUNT(*) FROM PROPIEDADES WHERE DNI = V.DNI) AS CUANTAS,
	(SELECT MAX(VALOR) FROM PROPIEDADES WHERE DNI = V.DNI) AS MAS_CARA
FROM VECINOS AS V
) AS AUX
WHERE AUX.SUMA > 4000000 AND AUX.CUANTAS > 1
