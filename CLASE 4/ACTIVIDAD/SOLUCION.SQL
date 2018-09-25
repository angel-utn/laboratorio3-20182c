-- A) Listar nombre del artículo, precio unitario, stock y nombre de la marca de todos los artículos 
-- que tengan marca. 
SELECT A.DESCRIPCION, A.PU, A.STOCK, M.DESCRIPCION FROM ARTICULOS AS A
INNER JOIN MARCAS AS M ON M.IDMARCA = A.IDMARCA

-- B) Listar nombre del artículo, precio unitario, stock y nombre de la marca de todos los artículos. 
-- Incluso si no tienen marca. 
SELECT A.DESCRIPCION, A.PU, A.STOCK, M.DESCRIPCION FROM ARTICULOS AS A
LEFT JOIN MARCAS AS M ON M.IDMARCA = A.IDMARCA

SELECT A.DESCRIPCION, A.PU, A.STOCK, M.DESCRIPCION FROM MARCAS AS M
RIGHT JOIN ARTICULOS AS A ON M.IDMARCA = A.IDMARCA

-- C) Listar para cada venta el código de venta, el nombre y apellido del cliente comprador y el 
-- nombre de la ciudad donde vive. 
SELECT V.IDVENTA, CLI.APELLIDO, CLI.NOMBRE, LOC.NOMBRE FROM VENTAS AS V
INNER JOIN CLIENTES AS CLI ON CLI.DNI = V.DNI
INNER JOIN LOCALIDADES AS LOC ON LOC.IDLOCALIDAD = CLI.IDLOCALIDAD

--D) Listar para cada venta el código de venta, la fecha, el nombre de los artículos vendidos, la 
--cantidad de artículos vendidos y su precio y la marca del artículo si tiene. 
SELECT V.IDVENTA, A.DESCRIPCION, AXV.CANTIDAD, AXV.PU, M.DESCRIPCION FROM VENTAS AS V
INNER JOIN ARTICULOS_X_VENTA AS AXV ON V.IDVENTA = AXV.IDVENTA
INNER JOIN ARTICULOS AS A ON A.IDARTICULO = AXV.IDARTICULO
RIGHT JOIN MARCAS AS M ON M.IDMARCA = A.IDMARCA

-- E) Listar para cada cliente el nombre y apellido, el sexo, la calle, el nombre de la localidad, 
-- provincia y país donde vive. Solo de los clientes que hayan nacido luego del año 1990. 
SELECT CLI.APELLIDO, CLI.NOMBRE, CLI.SEXO, CLI.CALLE, LOC.NOMBRE, PR.NOMBRE, PA.NOMBRE
FROM CLIENTES AS CLI
INNER JOIN LOCALIDADES AS LOC ON LOC.IDLOCALIDAD = CLI.IDLOCALIDAD
INNER JOIN PROVINCIAS AS PR ON PR.IDPROVINCIA = LOC.IDPROVINCIA
INNER JOIN PAISES AS PA ON PA.IDPAIS = PR.IDPAIS
WHERE YEAR(CLI.FNAC) > 1990

-- F) Listar el apellido y nombre de todos los clientes que no hayan comprado nunca. 
SELECT CLI.APELLIDO, CLI.NOMBRE FROM CLIENTES AS CLI
LEFT JOIN VENTAS AS V ON V.DNI = CLI.DNI
WHERE V.DNI IS NULL

-- G) Listar para cada artículo, el nombre de la/s categoría/s a la que pertenece. 
SELECT A.DESCRIPCION, C.CATEGORIA FROM ARTICULOS AS A
INNER JOIN CATEGORIAS_X_ARTICULO AS CXA ON CXA.IDARTICULO = A.IDARTICULO
INNER JOIN CATEGORIAS AS C ON C.IDCATEGORIA = CXA.IDCATEGORIA

-- H) Listar todos los clientes que no vivan en los países "Argentina", "Chile" ni "Uruguay". 
SELECT CLI.* FROM CLIENTES AS CLI 
INNER JOIN LOCALIDADES AS LOC ON LOC.IDLOCALIDAD = CLI.IDLOCALIDAD
INNER JOIN PROVINCIAS AS PR ON PR.IDPROVINCIA = LOC.IDPROVINCIA
INNER JOIN PAISES AS PA ON PA.IDPAIS = PR.IDPAIS
WHERE PA.NOMBRE NOT IN ('ARGENTINA', 'CHILE', 'PARAGUAY')

-- I) Listar todos los artículos nacionales cuyo precio sea mayor a $40 y pertenezca a la categoría 
-- "Pan Lactal" ó "Mermeladas". 
SELECT ART.* FROM ARTICULOS AS ART
INNER JOIN CATEGORIAS_X_ARTICULO AS CXA ON CXA.IDARTICULO = ART.IDARTICULO
INNER JOIN CATEGORIAS AS C ON C.IDCATEGORIA = CXA.IDCATEGORIA
WHERE ART.PU > 40 AND C.CATEGORIA IN ('PAN LACTAL', 'MERMELADAS')

-- J) Listar los meses y años en que haya habido ventas. (NOTA: Se deberá mostrar el número de 
-- mes en una columna y número de año en otra. No se admitirán duplicados) 
SELECT DISTINCT MONTH(V.FECHA), YEAR(V.FECHA) FROM VENTAS AS V
INNER JOIN ARTICULOS_X_VENTA AS AXV ON V.IDVENTA = AXV.IDVENTA

-- K) Listar el cliente más joven que viva en el país 'Uruguay'. (NOTA: El listado deberá contener 
-- únicamente el nombre y apellido del cliente). 
SELECT TOP 1 CLI.* FROM CLIENTES AS CLI
INNER JOIN LOCALIDADES AS LOC ON LOC.IDLOCALIDAD = CLI.IDLOCALIDAD
INNER JOIN PROVINCIAS AS PR ON PR.IDPROVINCIA = LOC.IDPROVINCIA
INNER JOIN PAISES AS PA ON PA.IDPAIS = PR.IDPAIS
WHERE PA.NOMBRE = 'URUGUAY'
ORDER BY CLI.FNAC DESC
