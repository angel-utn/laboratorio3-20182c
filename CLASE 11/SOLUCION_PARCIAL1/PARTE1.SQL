/*
Parte 1 - (15 puntos) 
Utilizando el lenguaje T-SQL crear una base de datos, 
tablas y restricciones que permitan 
representar una relación de Muchos a Muchos con las 
siguientes entidades: 
Pizza ? Ingrediente 
 
Sabiendo que: 
- La pizza se identifica con un código autonumérico. 
- El ingrediente se identifica con un código autonumérico. 
- Las pizzas deben registrar el precio de venta y un nombre comercial. 
- Los ingredientes deben registrar un nombre. 
- Para cada ingrediente de una pizza se debe registrar 
la cantidad utilizada en formato 
Decimal (6, 2) y un tipo de ingrediente que debe 
estar relacionado con la tabla Tipos 
Ingredientes. 
*/
USE master
GO
DROP DATABASE PARTE1_20182C
GO
CREATE DATABASE PARTE1_20182C
GO
USE PARTE1_20182C
GO
CREATE TABLE TIPOS_INGREDIENTES(
ID INT NOT NULL PRIMARY KEY,
TIPO VARCHAR(50) NOT NULL
)
GO
CREATE TABLE PIZZAS(
	ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	NOMBRE VARCHAR(50) NOT NULL,
	PRECIO MONEY NOT NULL
)
GO
CREATE TABLE INGREDIENTES(
	ID INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	NOMBRE VARCHAR(50) NOT NULL,
	IDTIPO INT NOT NULL FOREIGN KEY REFERENCES TIPOS_INGREDIENTES(ID)
)
GO
CREATE TABLE INGREDIENTES_X_PIZZA(
 IDPIZZA INT NOT NULL FOREIGN KEY REFERENCES PIZZAS(ID),
 IDINGREDIENTE INT NOT NULL FOREIGN KEY REFERENCES INGREDIENTES(ID),
 CANTIDAD DECIMAL(6, 2) NOT NULL,
 PRIMARY KEY (IDPIZZA, IDINGREDIENTE)
)