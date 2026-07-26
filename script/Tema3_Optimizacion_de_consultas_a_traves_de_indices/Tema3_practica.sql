-------------------------------------------------------------------
    -- TEMA 3: OPTIMIZACIÓN DE CONSULTAS A TRAVÉS DE ÍNDICES
-------------------------------------------------------------------

USE Ley_Justina;
GO

------------------------------------------------------------------- 
             -- 1) CREACIÓN DE TABLAS PARA PRUEBAS
-------------------------------------------------------------------

-- Tabla sin índice
CREATE TABLE Transplante1 (
    id_transplante INT IDENTITY(1,1) NOT NULL,
    fecha_trasplante DATE NOT NULL,
    estado INT NOT NULL,
    observacion VARCHAR(100) NOT NULL,
    id_organo INT NOT NULL,
    id_donante INT NOT NULL,
    id_hospital INT NOT NULL,
    id_doctor INT NOT NULL,
    id_receptor INT NOT NULL,
    CONSTRAINT PK_Transplante1 PRIMARY KEY (id_transplante)
);

-- Tabla para aplicar índices y comparar rendimiento
CREATE TABLE Transplante2 (
    id_transplante INT IDENTITY(1,1) NOT NULL,
    fecha_trasplante DATE NOT NULL,
    estado INT NOT NULL,
    observacion VARCHAR(100) NOT NULL,
    id_organo INT NOT NULL,
    id_donante INT NOT NULL,
    id_hospital INT NOT NULL,
    id_doctor INT NOT NULL,
    id_receptor INT NOT NULL,
    CONSTRAINT PK_Transplante2 PRIMARY KEY (id_transplante)
);

------------------------------------------------------------------- 
      -- 2) CARGA MASIVA DE DATOS (1 MILLÓN DE REGISTROS)
-------------------------------------------------------------------

DECLARE @FechaFin DATE = '2024-12-31';
DECLARE @FechaInicio DATE = DATEADD(DAY, -365, @FechaFin);
DECLARE @NumRegistros INT = 1000000;

-- Tabla temporal para almacenar los registros generados
CREATE TABLE #TempTransplante (
    fecha_trasplante DATE,
    estado INT,
    observacion VARCHAR(100),
    id_organo INT,
    id_donante INT,
    id_hospital INT,
    id_doctor INT,
    id_receptor INT
);

DECLARE @i INT = 1;

WHILE @i <= @NumRegistros
BEGIN
    DECLARE @RandomDays INT = FLOOR(RAND(CHECKSUM(NEWID())) * DATEDIFF(DAY, @FechaInicio, @FechaFin));
    DECLARE @FechaTransplante DATE = DATEADD(DAY, @RandomDays, @FechaInicio);

    DECLARE @Estado INT = ABS(CHECKSUM(NEWID())) % 3 + 1;
    DECLARE @Observacion VARCHAR(100) = 'Observacion ' + CAST(@i AS VARCHAR(20));
    DECLARE @IdOrgano INT = ABS(CHECKSUM(NEWID())) % 5 + 1;
    DECLARE @IdDonante INT = ABS(CHECKSUM(NEWID())) % 5 + 1;
    DECLARE @IdHospital INT = ABS(CHECKSUM(NEWID())) % 3 + 1;
    DECLARE @IdDoctor INT = ABS(CHECKSUM(NEWID())) % 5 + 1;
    DECLARE @IdReceptor INT = ABS(CHECKSUM(NEWID())) % 5 + 1;

    INSERT INTO #TempTransplante (
        fecha_trasplante, estado, observacion, id_organo, id_donante, id_hospital, id_doctor, id_receptor
    )
    VALUES (
        @FechaTransplante, @Estado, @Observacion, @IdOrgano, @IdDonante, @IdHospital, @IdDoctor, @IdReceptor
    );

    SET @i = @i + 1;
END;

INSERT INTO Transplante1 (
    fecha_trasplante, estado, observacion, id_organo, id_donante, id_hospital, id_doctor, id_receptor
)
SELECT
    fecha_trasplante, estado, observacion, id_organo, id_donante, id_hospital, id_doctor, id_receptor
FROM #TempTransplante;

INSERT INTO Transplante2 (
    fecha_trasplante, estado, observacion, id_organo, id_donante, id_hospital, id_doctor, id_receptor
)
SELECT
    fecha_trasplante, estado, observacion, id_organo, id_donante, id_hospital, id_doctor, id_receptor
FROM #TempTransplante;

DROP TABLE #TempTransplante;

------------------------------------------------------------------- 
    -- 3) BÚSQUEDA SIN ÍNDICE Y REGISTRO DEL PLAN DE EJECUCIÓN
-------------------------------------------------------------------

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT *
FROM Transplante1
WHERE fecha_trasplante BETWEEN '2024-01-01' AND '2024-02-01'
ORDER BY fecha_trasplante ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

------------------------------------------------------------------- 
 -- 4) CREAR ÍNDICE AGRUPADO SOBRE LA FECHA Y REPETIR LA CONSULTA
-------------------------------------------------------------------

-- Eliminar la clave primaria para poder crear el índice agrupado sobre la fecha
ALTER TABLE Transplante2 DROP CONSTRAINT PK_Transplante2;

-- Crear índice agrupado sobre la columna fecha_trasplante
CREATE CLUSTERED INDEX IDX_Transplante2_Fecha
ON Transplante2(fecha_trasplante);

-- Volver a crear la clave primaria como no agrupada
ALTER TABLE Transplante2
ADD CONSTRAINT PK_Transplante2 PRIMARY KEY NONCLUSTERED (id_transplante);

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT *
FROM Transplante2
WHERE fecha_trasplante BETWEEN '2024-01-01' AND '2024-02-01'
ORDER BY fecha_trasplante ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

------------------------------------------------------------------- 
            -- 5) BORRAR ÍNDICE AGRUPADO CREADO
-------------------------------------------------------------------

DROP INDEX IDX_Transplante2_Fecha ON Transplante2;

------------------------------------------------------------------- 
    -- 6) CREAR ÍNDICE NO AGRUPADO CON COLUMNAS INCLUIDAS
-------------------------------------------------------------------

CREATE NONCLUSTERED INDEX IDX_Transplante2_Fecha_Incluye
ON Transplante2 (fecha_trasplante)
INCLUDE (id_transplante, estado, observacion);

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT *
FROM Transplante2
WHERE fecha_trasplante BETWEEN '2024-01-01' AND '2024-02-01'
ORDER BY fecha_trasplante ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

------------------------------------------------------------------- 
 -- 7) COMPARACIÓN FINAL ENTRE TABLA SIN ÍNDICE Y TABLA OPTIMIZADA
-------------------------------------------------------------------

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT *
FROM Transplante1
WHERE fecha_trasplante BETWEEN '2024-01-01' AND '2024-02-01'
ORDER BY fecha_trasplante ASC;

SELECT *
FROM Transplante2
WHERE fecha_trasplante BETWEEN '2024-01-01' AND '2024-02-01'
ORDER BY fecha_trasplante ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;