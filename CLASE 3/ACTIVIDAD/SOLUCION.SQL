-- A) Todos los campos de todos los clientes cuyo apellido finalice con la letra o. 
SELECT * FROM CLIENTES WHERE APELLIDO LIKE '%O'

--B) Todos los campos de todos los clientes de sexo femenino. 
SELECT * FROM CLIENTES WHERE SEXO = 'F'

-- C) Todos los campos de todos los clientes que hayan nacido luego del año 1986. 
SELECT * FROM CLIENTES WHERE YEAR(FNAC) > 1986

--D) Todos los campos de todos los clientes cuya fecha de nacimiento sea entre 1/1/1980 y 
--1/12/1990 ambos inclusive. 
SELECT * FROM CLIENTES WHERE FNAC BETWEEN '1/1/1980' AND '1/12/1990'

-- E) Todos los campos de todos los clientes cuyo apellido tenga dos letras CC seguidas. 
SELECT * FROM CLIENTES WHERE APELLIDO LIKE '%CC%'

-- F) Todos los campos de todos los clientes cuya fecha de nacimiento sea en el mes de Agosto. 
SELECT * FROM CLIENTES WHERE MONTH(FNAC) = 8

--G) Todos los campos de todos los clientes cuya año de nacimiento sea entre 1990 y 1999 ambos 
--inclusive. 
SELECT * FROM CLIENTES WHERE YEAR(FNAC) BETWEEN 1990 AND 1999

-- H) Todos los campos de todos los clientes cuyo DNI sea 1111, 2222, 3333 ó 4444. 
SELECT * FROM CLIENTES WHERE DNI IN ('1111', '2222', '3333', '4444')

-- I) Todos los campos del cliente más joven. 
SELECT TOP 1 * FROM CLIENTES ORDER BY FNAC DESC

-- J) Todos los campos de todas las marcas cuya descripción sea de dos palabras. 
SELECT * FROM MARCAS WHERE DESCRIPCION LIKE '% %'

-- K) Todos los campos de todos los artículos que tengan 'Light' en su descripción. 
SELECT * FROM ARTICULOS WHERE DESCRIPCION LIKE '%LIGHT%'

-- L) Todos los campos de todos los artículos que no tengan una marca asignada. 
SELECT * FROM ARTICULOS WHERE IDMARCA IS NULL

-- M) Descripción, stock y precio unitario con IVA de todos los artículos. (Incrementar 21% al PU) 
SELECT DESCRIPCION, STOCK, PU*1.21 AS PU_IVA FROM ARTICULOS

-- N) Descripción, stock y precio unitario de todos los artículos extranjeros. 
SELECT DESCRIPCION, STOCK, PU FROM ARTICULOS WHERE ORIGEN = 'I'

-- Ñ) Todos los campos de todos los artículos cuyo precio sea mayor a 75.
SELECT * FROM ARTICULOS WHERE PU > 75

--O) Todos los campos de todos los artículos cuyo precio sea 10, 20, 30, 40 ó 50. 
SELECT * FROM ARTICULOS WHERE PU IN (10, 20, 30, 40, 50)

-- P) Todos los campos de todos los artículos cuyos precios no sean 10, 20, 30, 40 ó 50. 
SELECT * FROM ARTICULOS WHERE PU NOT IN (10, 20, 30, 40, 50)

-- Q) Todos los campos de todos los artículos cuyo precio sea mayor a $100 ó menor a $20. 
SELECT * FROM ARTICULOS WHERE PU > 100 OR PU < 20

-- R) Todos los campos de todas las ventas que se realizaron en el segundo semestre de 2016. 
SELECT * FROM VENTAS WHERE MONTH(FECHA) > 6 AND YEAR(FECHA) = 2016

-- S) Todos los campos de todas las ventas que se realizaron el mes pasado. 
-- NO SE PUEDE RESOLVER FÁCILMENTE CON LO VISTO HASTA EL MOMENTO.
 
-- T) Todos los campos de todas las ventas no realizadas por el cliente 3333. 
SELECT * FROM VENTAS WHERE DNI NOT IN (3333)
