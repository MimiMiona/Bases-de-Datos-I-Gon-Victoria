-------------------------------------------------------------------
-- TEMA 3: OPTIMIZACIÓN DE CONSULTAS A TRAVÉS DE ÍNDICES
-------------------------------------------------------------------

USE Ley_Justina;
GO

-------------------------------------------------------------------
-- 1) PREPARACIÓN DE TABLAS
-------------------------------------------------------------------

IF OBJECT_ID('Transplante1') IS NOT NULL
    DROP TABLE Transplante1;

IF OBJECT_ID('Transplante2') IS NOT NULL
    DROP TABLE Transplante2;
GO

CREATE TABLE Transplante1
(
    id_transplante INT NOT NULL,
    fecha_trasplante DATE NOT NULL,
    estado INT NOT NULL,
    observacion VARCHAR(100),
    id_organo INT NOT NULL,
    id_donante INT NOT NULL,
    id_hospital INT NOT NULL,
    id_doctor INT NOT NULL,
    id_receptor INT NOT NULL,

    CONSTRAINT PK_Transplante1
        PRIMARY KEY CLUSTERED(id_transplante)
);

CREATE TABLE Transplante2
(
    id_transplante INT NOT NULL,
    fecha_trasplante DATE NOT NULL,
    estado INT NOT NULL,
    observacion VARCHAR(100),
    id_organo INT NOT NULL,
    id_donante INT NOT NULL,
    id_hospital INT NOT NULL,
    id_doctor INT NOT NULL,
    id_receptor INT NOT NULL,

    CONSTRAINT PK_Transplante2
        PRIMARY KEY CLUSTERED(id_transplante)
);
GO

-------------------------------------------------------------------
-- 2) CARGA MASIVA DE DATOS
-------------------------------------------------------------------

PRINT 'Generando 1.000.000 de registros...';

DECLARE @Cantidad INT = 1000000;

;WITH
E1(N) AS (SELECT 1 UNION ALL SELECT 1),
E2(N) AS (SELECT 1 FROM E1 a CROSS JOIN E1 b),
E4(N) AS (SELECT 1 FROM E2 a CROSS JOIN E2 b),
E8(N) AS (SELECT 1 FROM E4 a CROSS JOIN E4 b),
E16(N) AS (SELECT 1 FROM E8 a CROSS JOIN E8 b),
E32(N) AS (SELECT 1 FROM E16 a CROSS JOIN E16 b),
Numeros AS
(
    SELECT TOP (@Cantidad)
        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Numero
    FROM E32
)

INSERT INTO Transplante1
SELECT
    Numero,
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, '2024-01-01'),
    ABS(CHECKSUM(NEWID())) % 3,
    CONCAT('Observacion ',Numero),
    1,
    1,
    1,
    1,
    1
FROM Numeros;

INSERT INTO Transplante2
SELECT *
FROM Transplante1;

PRINT 'Carga finalizada.';
GO

-------------------------------------------------------------------
-- 3) CONSULTA SIN ÍNDICES
-------------------------------------------------------------------

PRINT '==============================';
PRINT 'PRUEBA 1 - SIN INDICE';
PRINT '==============================';

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    id_transplante,
    fecha_trasplante,
    estado,
    observacion
FROM Transplante1
WHERE fecha_trasplante
BETWEEN '2024-03-01' AND '2024-04-01'
ORDER BY fecha_trasplante;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

GO

/*
Resultado obtenido

Plan de ejecución:
Clustered Index Scan

Lecturas lógicas:
7830

Tiempo de CPU:
344 ms

Tiempo transcurrido:
1111 ms
*/

-------------------------------------------------------------------
-- 4) ÍNDICE CLUSTERED
-------------------------------------------------------------------

PRINT '==============================';
PRINT 'PRUEBA 2 - CLUSTERED INDEX';
PRINT '==============================';

ALTER TABLE Transplante2
DROP CONSTRAINT PK_Transplante2;

GO

CREATE CLUSTERED INDEX IDX_Fecha_Clustered
ON Transplante2(fecha_trasplante);

GO

ALTER TABLE Transplante2
ADD CONSTRAINT PK_Transplante2
PRIMARY KEY NONCLUSTERED(id_transplante);

GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    id_transplante,
    fecha_trasplante,
    estado,
    observacion
FROM Transplante2
WHERE fecha_trasplante
BETWEEN '2024-03-01' AND '2024-04-01'
ORDER BY fecha_trasplante;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

GO

/*
Resultado obtenido

Plan de ejecución:
Clustered Index 

Lecturas lógicas: 754

Tiempo de CPU: 78 ms

Tiempo transcurrido: 855 ms
*/

-------------------------------------------------------------------
-- 5) ELIMINAR ÍNDICE CLUSTERED
-------------------------------------------------------------------

DROP INDEX IDX_Fecha_Clustered
ON Transplante2;

GO

-------------------------------------------------------------------
-- 6) ÍNDICE NO CLUSTERED CUBRIENTE
-------------------------------------------------------------------

PRINT '==============================';
PRINT 'PRUEBA 3 - NONCLUSTERED INDEX';
PRINT '==============================';

CREATE NONCLUSTERED INDEX IDX_Fecha_Covering
ON Transplante2(fecha_trasplante)
INCLUDE
(
    id_transplante,
    estado,
    observacion
);

GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    id_transplante,
    fecha_trasplante,
    estado,
    observacion
FROM Transplante2
WHERE fecha_trasplante
BETWEEN '2024-03-01' AND '2024-04-01'
ORDER BY fecha_trasplante;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

GO

/*
Resultado obtenido

-- Plan de ejecución: NonClustered Index Seek
-- Lecturas lógicas: 513
-- Tiempo CPU: 31 ms
-- Tiempo transcurrido: 864 ms
*/

-------------------------------------------------------------------
-- 7) COMPARACIÓN FINAL
-------------------------------------------------------------------

PRINT '==============================';
PRINT 'COMPARACIÓN FINAL';
PRINT '==============================';

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    id_transplante,
    fecha_trasplante,
    estado,
    observacion
FROM Transplante1
WHERE fecha_trasplante
BETWEEN '2024-03-01' AND '2024-04-01'
ORDER BY fecha_trasplante;

SELECT
    id_transplante,
    fecha_trasplante,
    estado,
    observacion
FROM Transplante2
WHERE fecha_trasplante
BETWEEN '2024-03-01' AND '2024-04-01'
ORDER BY fecha_trasplante;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

-- COMPARACIÓN FINAL
-- Sin índice:
--    Lecturas lógicas: 7830
--    CPU: 296 ms
--    Tiempo: 1148 ms
--
-- Con índice NonClustered:
--    Lecturas lógicas: 513
--    CPU: 16 ms
--    Tiempo: 857 ms
--
-- CONCLUSIÓN:
/*La utilización de un índice no agrupado (NonClustered Index)
permitió disminuir considerablemente el costo de la consulta.

Comparado con la tabla sin índice:

- Las lecturas lógicas pasaron de 7830 a 513 páginas.
- El tiempo de CPU disminuyó de 296 ms a 16 ms.
- El tiempo total también se redujo.

Esto demuestra que una correcta estrategia de indexación mejora
significativamente el rendimiento de las consultas sobre grandes
volúmenes de datos. *\