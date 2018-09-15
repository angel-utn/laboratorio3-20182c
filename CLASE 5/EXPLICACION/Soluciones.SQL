-- 1) La cantidad de socios
SELECT COUNT(*) AS CANTIDAD FROM SOCIOS

--2) La cantidad de sedes con teléfono
SELECT COUNT(*) AS CANTIDAD FROM SEDES WHERE TELEFONO IS NOT NULL

SELECT COUNT(TELEFONO) AS CANTIDAD FROM SEDES

-- 3) La cantidad de actividades de equipo.
SELECT COUNT(*) AS CANTIDADE FROM ACTIVIDADES WHERE TIPO = 'E'

-- 3) La suma de todos los pagos realizados.
SELECT SUM(IMPORTE) AS TOTAL FROM PAGOS

-- 4) La suma de todos los pagos en Julio de 2018.
SELECT SUM(IMPORTE) AS TOTAL_JULIO FROM PAGOS WHERE MES=7 AND AÑO=2018

-- 5) El promedio de costo de las actividades.
SELECT AVG(COSTO) AS PROM FROM ACTIVIDADES

-- 6) El costo máximo de las actividades individuales.
SELECT MAX(COSTO) AS MAXI FROM ACTIVIDADES WHERE TIPO = 'I'

-- 7) El pago mínimo entre todos los pagos.
SELECT MIN(IMPORTE) AS MINI FROM PAGOS

-- 6) Por cada sede, mostrar la dirección y 
-- la cantidad de actividades que se realizan en ellas.
SELECT S.DIRECCION, COUNT(*) AS CANT FROM SEDES AS S
INNER JOIN ACTIVIDADES AS A ON A.IDSEDE = S.IDSEDE
GROUP BY S.DIRECCION

-- 7) Por cada localidad, mostrar el nombre de la 
-- localidad y la cantidad de sedes ubicadas en ellas.
SELECT L.LOCALIDAD, COUNT(*) AS CANT FROM LOCALIDADES AS L
INNER JOIN SEDES AS S ON L.CP = S.CP
GROUP BY L.LOCALIDAD

-- 8) Igual al anterior, pero listar también las localidades 
--que no tienen sedes en ellas.
SELECT L.LOCALIDAD, COUNT(S.CP) AS CANT FROM LOCALIDADES AS L
LEFT JOIN SEDES AS S ON L.CP = S.CP
GROUP BY L.LOCALIDAD

-- 9) Por cada socio, listar el nombre y apellido 
--y la cantidad de actividades que realiza cada uno.
SELECT S.APELLIDO, S.NOMBRES, COUNT(*) AS CANT FROM SOCIOS AS S
INNER JOIN ACTIVIDADES_X_SOCIO AS AXS ON AXS.LEGAJO = S.LEGAJO
INNER JOIN ACTIVIDADES AS A ON A.IDACTIVIDAD = AXS.IDACTIVIDAD
GROUP BY S.APELLIDO, S.NOMBRES

-- 10) Igual al anterior pero listar a los socios 
-- que sólo realicen una actividad.
SELECT S.APELLIDO, S.NOMBRES, COUNT(*) AS CANT FROM SOCIOS AS S
INNER JOIN ACTIVIDADES_X_SOCIO AS AXS ON AXS.LEGAJO = S.LEGAJO
INNER JOIN ACTIVIDADES AS A ON A.IDACTIVIDAD = AXS.IDACTIVIDAD
GROUP BY S.APELLIDO, S.NOMBRES
HAVING COUNT(*) = 1

-- 9) Por cada socio, listar el nombre y apellido 
-- y la cantidad de pagos realizados.
SELECT S.APELLIDO, S.NOMBRES, COUNT(*) AS CANT FROM SOCIOS AS S
INNER JOIN PAGOS AS P ON P.LEGAJO = S.LEGAJO
GROUP BY S.APELLIDO, S.NOMBRES

-- 10) Igual al anterior pero solamente listar 
-- aquellos socios con cero cantidad de pagos realizados.
SELECT S.APELLIDO, S.NOMBRES, COUNT(P.IMPORTE) AS CANT FROM SOCIOS AS S
LEFT JOIN PAGOS AS P ON P.LEGAJO = S.LEGAJO
GROUP BY S.APELLIDO, S.NOMBRES
HAVING COUNT(P.IMPORTE) = 0

-- 10) Por cada socio, listar el nombre y apellido 
-- y el total abonado en concepto de pagos.
SELECT S.APELLIDO, S.NOMBRES, SUM(P.IMPORTE) AS CANT FROM SOCIOS AS S
LEFT JOIN PAGOS AS P ON P.LEGAJO = S.LEGAJO
GROUP BY S.APELLIDO, S.NOMBRES

-- 11) Igual al anterior pero sólo listar los socios 
-- que hayan abonado más de $1000 en total en concepto de pagos.
SELECT S.APELLIDO, S.NOMBRES, SUM(P.IMPORTE) AS CANT FROM SOCIOS AS S
LEFT JOIN PAGOS AS P ON P.LEGAJO = S.LEGAJO
GROUP BY S.APELLIDO, S.NOMBRES
HAVING SUM(P.IMPORTE) > 1000

-- 11) Por cada socio, listar el máximo 
-- monto abonado en concepto de pagos.
SELECT S.APELLIDO, S.NOMBRES, MAX(P.IMPORTE) AS CANT FROM SOCIOS AS S
INNER JOIN PAGOS AS P ON P.LEGAJO = S.LEGAJO
GROUP BY S.APELLIDO, S.NOMBRES

-- 12) La cantidad de socios que realicen 
-- alguna actividad en equipo.
SELECT COUNT(DISTINCT AXS.LEGAJO) AS CANT FROM ACTIVIDADES_X_SOCIO AS AXS
INNER JOIN ACTIVIDADES AS A ON A.IDACTIVIDAD = AXS.IDACTIVIDAD
WHERE A.TIPO = 'E'
