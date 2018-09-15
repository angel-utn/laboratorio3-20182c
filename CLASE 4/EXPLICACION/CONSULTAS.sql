-- JOINS

-- 1) Listar las localidades con 
-- sus respectivas provincias.
SELECT L.LOCALIDAD, P.PROVINCIA FROM LOCALIDADES AS L
INNER JOIN PROVINCIAS AS P ON L.IDPROVINCIA = P.IDPROVINCIA

-- 1A) Listar las localidades con sus respectivas provincias. 
-- Si hay provincias sin localidad incluirlas al listado.
SELECT L.*, P.PROVINCIA FROM LOCALIDADES AS L
RIGHT JOIN PROVINCIAS AS P ON L.IDPROVINCIA = P.IDPROVINCIA

-- 2) Por cada sede listar el nombre , la dirección, 
--el teléfono, el nombre de la localidad.
SELECT S.NOMBRE, S.DIRECCION, S.TELEFONO, L.LOCALIDAD
FROM SEDES AS S 
INNER JOIN LOCALIDADES AS L ON L.CP = S.CP

-- 2B) Por cada sede, listar el nombre de la localidad 
--y el nombre de la sede. Si hay localidades sin sedes 
--incluirlas al listado.
SELECT L.LOCALIDAD, S.NOMBRE FROM LOCALIDADES AS L
LEFT JOIN SEDES AS S ON L.CP = S.CP

-- 2C) Listar todas las sedes, 
-- incluyendo nombre de sede, dirección, nombre de localidad y 
-- de la provincia.
SELECT S.NOMBRE, S.DIRECCION, L.LOCALIDAD, P.PROVINCIA
FROM SEDES AS S
RIGHT JOIN LOCALIDADES AS L ON L.CP = S.CP
RIGHT JOIN PROVINCIAS AS P ON P.IDPROVINCIA = L.IDPROVINCIA

-- 3) Por cada pago realizado listar la fecha de pago, 
-- el mes y año del período, el importe del pago y el 
-- nombre y apellido del socio.
SELECT P.FECHA, P.MES, P.AÑO, P.IMPORTE, S.NOMBRES, S.APELLIDO
FROM PAGOS AS P
INNER JOIN SOCIOS AS S ON P.LEGAJO = S.LEGAJO

-- 4) Igual al anterior, pero si hay algún socio que nunca haya abonado 
-- deberá figurar en el listado.

SELECT P.FECHA, P.MES, P.AÑO, P.IMPORTE, S.NOMBRES, S.APELLIDO
FROM PAGOS AS P
RIGHT JOIN SOCIOS AS S ON P.LEGAJO = S.LEGAJO ORDER BY P.FECHA


-- 5) Listar cada actividad que realiza cada socio. 
--Se deberá informar, el apellido y nombre del socio, 
--el nombre de la actividad, el tipo de actividad, el costo 
--y el nombre de la sede donde se realiza.
SELECT SC.NOMBRES,SC.APELLIDO,A.NOMBRE,
CASE A.TIPO
WHEN 'I' THEN 'INDIVIDUAL'
WHEN 'E' THEN 'EQUIPO'
END AS TIPO_TEXTUAL,
CASE
WHEN A.COSTO > 400 THEN 'MUY CARO'
ELSE 'NO TAN CARO' END AS COSTO_TEXTUAL,
S.NOMBRE FROM SOCIOS AS SC
INNER JOIN ACTIVIDADES_X_SOCIO AS AXS ON AXS.LEGAJO=SC.LEGAJO
INNER JOIN ACTIVIDADES AS A ON A.IDACTIVIDAD=AXS.IDACTIVIDAD
INNER JOIN SEDES AS S ON S.IDSEDE=A.IDSEDE

-- 6) Listar todos los socios que realicen 
-- actividades cuyo costo sea mayor a $300.
SELECT DISTINCT S.*
FROM SOCIOS AS S
INNER JOIN ACTIVIDADES_X_SOCIO AS AXS
ON S.LEGAJO = AXS.LEGAJO
INNER JOIN ACTIVIDADES AS A
ON AXS.IDACTIVIDAD = A.IDACTIVIDAD
WHERE A.COSTO > 300

-- 7) Listar todos los socios que no hayan abonado ningún pago.
SELECT S.NOMBRES, S.APELLIDO
FROM PAGOS AS P
RIGHT JOIN SOCIOS AS S ON P.LEGAJO = S.LEGAJO 
WHERE P.IMPORTE IS NULL
ORDER BY P.FECHA

