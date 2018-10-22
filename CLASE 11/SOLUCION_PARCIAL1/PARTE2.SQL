-- SOLUCION.SQL
/*
1) - Por cada vecino, listar el apellido y nombre, tipo de propiedad, 
domicilio, porcentaje de superficie construida (sobre el total), 
valor de la propiedad y antiguedad. Sólo listar registros de 
propiedades de costo mayor a un millón de pesos
o que tengan menos de 5 años de antigüedad. (10 puntos)
*/

SELECT V.APELLIDOS, V.NOMBRES, TP.TIPO, P.DOMICILIO,
	P.SUPERFICIE_CONSTRUIDA/P.SUPERFICIE*100 AS PORC,
	P.VALOR, P.ANTIGUEDAD
FROM VECINOS AS V
INNER JOIN PROPIEDADES AS P ON P.DNI = V.DNI
INNER JOIN TIPOS_PROPIEDADES AS TP ON TP.ID = P.IDTIPO
WHERE P.VALOR > 1000000 OR P.ANTIGUEDAD < 5

/*
2) - Listar todos los datos de los vecinos que no tengan 
propiedades de más de 80m2 de superficie construida. (20 puntos)
*/
SELECT * FROM VECINOS WHERE DNI NOT IN (
	SELECT DISTINCT DNI FROM PROPIEDADES WHERE SUPERFICIE_CONSTRUIDA > 80
)

/*
3) - Listar por cada vecino el apellido y nombres, 
la cantidad de propiedades sin superficie construida y 
la cantidad de propiedades con superficie construida que posee.
(25 puntos)
*/
SELECT V.APELLIDOS, V.NOMBRES, 
	(SELECT COUNT(*) FROM PROPIEDADES WHERE DNI=V.DNI AND SUPERFICIE_CONSTRUIDA > 0) AS CANT_CON, 
	(SELECT COUNT(*) FROM PROPIEDADES WHERE DNI=V.DNI AND SUPERFICIE_CONSTRUIDA = 0) AS CANT_SIN
FROM VECINOS AS V

/*
4) - Listar por cada tipo de propiedad el valor promedio. 
Sólo listar aquellos
registros cuyo valor promedio supere los $900000.
(15 puntos)
*/
SELECT TP.TIPO, AVG(P.VALOR) AS PROMEDIO
FROM TIPOS_PROPIEDADES AS TP
INNER JOIN PROPIEDADES AS P ON P.IDTIPO = TP.ID
GROUP BY TP.TIPO
HAVING AVG(P.VALOR) > 900000
/*
5) - Por cada vecino, listar apellido y nombres y 
el total acumulado en concepto de propiedades. 
Si un vecino no posee propiedades deberá 
figurar acumulando 0. (15 puntos)
*/
SELECT V.APELLIDOS, V.NOMBRES, ISNULL(SUM(P.VALOR),0) AS TOTAL
FROM VECINOS AS V
LEFT JOIN PROPIEDADES AS P ON P.DNI = V.DNI
GROUP BY V.APELLIDOS, V.NOMBRES