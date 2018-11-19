/*
A) Hacer un trigger que al ingresar una función verifique 
que no haya más de tres funciones en la misma sala para el 
mismo día o que no haya otra función de la misma obra para 
la misma sala en el mismo día. De ocurrir lo primero 
indicar "Sala no disponible", en caso de ocurrir lo segundo 
indicar "Función repetida". De lo contrario, realizar el 
ingreso.
NOTA: Sólo tener en cuenta las funciones que no se 
encuentren canceladas.
*/
CREATE TRIGGER TR_PUNTOA ON FUNCIONES
INSTEAD OF INSERT
AS
BEGIN
    BEGIN TRY
    DECLARE @FUNCIONES_TOTALES INT
	DECLARE @FUNCIONES_OBRA INT
	DECLARE @IDOBRA INT
	DECLARE @IDSALA INT
	DECLARE @FECHA DATE
	
	SELECT @IDOBRA=IDOBRA, @IDSALA=IDSALA, @FECHA=FECHA FROM INSERTED
	
	-- VERIFICACIÓN NO MÁS DE 3 FUNCIONES MISMO DÍA, MISMA SALA
	SELECT @FUNCIONES_TOTALES = COUNT(*) FROM FUNCIONES
	WHERE IDSALA = @IDSALA AND FECHA = @FECHA AND CANCELADA = 0
	
	IF @FUNCIONES_TOTALES+1 > 3 BEGIN
		RAISERROR('SALA NO DISPONIBLE', 16, 1)
	END
	
	-- VERIFICACIÓN NO MÁS DE 1 FUNCIÓN MISMO DÍA, MISMA SALA, MISMA OBRA
	SELECT @FUNCIONES_OBRA = COUNT(*) FROM FUNCIONES
	WHERE IDOBRA=@IDOBRA AND IDSALA = @IDSALA 
	AND FECHA = @FECHA AND CANCELADA = 0
	
	IF @FUNCIONES_OBRA+1 > 1 BEGIN
	  RAISERROR('FUNCION REPETIDA', 16, 1)
	END
	
	INSERT INTO FUNCIONES (IDOBRA, IDSALA, FECHA, CANCELADA)
	SELECT IDOBRA, IDSALA, FECHA, CANCELADA FROM INSERTED

	
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
	END CATCH
END


-- FUNCION REPETIDA
INSERT INTO FUNCIONES (IDOBRA, IDSALA, FECHA, CANCELADA) 
VALUES (1, 1, '2018/11/25', 0)

-- OK
INSERT INTO FUNCIONES (IDOBRA, IDSALA, FECHA, CANCELADA) 
VALUES (2, 1, '2018/11/25', 0)
-- OK
INSERT INTO FUNCIONES (IDOBRA, IDSALA, FECHA, CANCELADA) 
VALUES (3, 1, '2018/11/25', 0)
-- SALA OCUPADA
INSERT INTO FUNCIONES (IDOBRA, IDSALA, FECHA, CANCELADA) 
VALUES (4, 1, '2018/11/25', 0)


/*
B) Hacer un trigger que al eliminar una obra se cancele la 
misma si todas las funciones de la obra se encuentran 
realizadas. Es decir, cuyas fechas de función sean 
anteriores al día de hoy. En caso de haber alguna 
función pendiente indicarlo con un mensaje aclaratorio. 
Caso contrario, cancelar la obra.
*/

CREATE TRIGGER TR_PUNTOB ON OBRAS
INSTEAD OF DELETE
AS
BEGIN
	
	DECLARE @FUNCIONES_PENDIENTES INT
	DECLARE @IDOBRA INT
	
	SELECT @IDOBRA = IDOBRA FROM DELETED
	
	SELECT @FUNCIONES_PENDIENTES = COUNT(*) FROM
	FUNCIONES WHERE IDOBRA = @IDOBRA AND FECHA > GETDATE()
	
	IF @FUNCIONES_PENDIENTES = 0 BEGIN
		UPDATE OBRAS SET CANCELADA = 1
		WHERE IDOBRA = @IDOBRA
	END
	ELSE BEGIN
	 RAISERROR('FUNCIONES PENDIENTES', 16, 1)
	END
END

-- FUNCIONES PENDIENTES
DELETE FROM OBRAS WHERE IDOBRA = 2

-- OK (SE CANCELA LA OBRA)
DELETE FROM OBRAS WHERE IDOBRA = 4


/*
C) Hacer un listado que muestre los datos completos de las 
obras que hayan tenido funciones en salas de tipo "Privado" 
pero no en salas de tipo "Públicas". Incluir a los datos de 
la obra la cantidad de funciones que registra.
NOTA: Indistintamente si la función se encuentra cancelada 
o no.
*/
SELECT AUX.OBRA, AUX.ESTRENO, AUX.COSTO_X_FUNCION, AUX.CANCELADA, AUX.PRIVADAS+AUX.PUBLICAS AS TOTAL
FROM (

SELECT O.*, 
(SELECT COUNT(*) FROM FUNCIONES AS F
 INNER JOIN SALAS AS S ON S.IDSALA = F.IDSALA
 WHERE S.TIPO IN (1,2) AND F.IDOBRA = O.IDOBRA) AS PUBLICAS,
 
(SELECT COUNT(*) FROM FUNCIONES AS F
 INNER JOIN SALAS AS S ON S.IDSALA = F.IDSALA
 WHERE S.TIPO IN (3) AND F.IDOBRA = O.IDOBRA) AS PRIVADAS 
 FROM OBRAS AS O
) AS AUX
WHERE AUX.PRIVADAS > 0 AND AUX.PUBLICAS = 0

/*
D) Hacer un procedimiento almacenado que reciba como 
parámetro un mes y año y liste todas las obras que 
registraron al menos una función cancelada en ese período.
Deberá informar: Nombre de la obra y Fecha de estreno,
*/
CREATE PROCEDURE SP_PUNTOD(
 @MES INT,
 @ANIO INT
)
AS
BEGIN
	
	SELECT O.* FROM OBRAS AS O
	WHERE O.IDOBRA IN(
		SELECT DISTINCT IDOBRA FROM FUNCIONES
		WHERE CANCELADA = 1 AND MONTH(FECHA) = @MES AND
		YEAR(FECHA) = @ANIO 
	)
	
END

EXEC SP_PUNTOD 11, 2018