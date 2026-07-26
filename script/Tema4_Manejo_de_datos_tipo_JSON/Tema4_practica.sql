-------------------------------------------------------------------
            -- TEMA 4: MANEJO DE TIPO DE DATOS JSON
-------------------------------------------------------------------

IF DB_ID('Ley_Justina') IS NULL
    CREATE DATABASE Ley_Justina;
GO

USE Ley_Justina;
GO

-------------------------------------------------------------------
              -- EJEMPLOS BASICOS DE GENERACION DE JSON
-------------------------------------------------------------------

-- Convertir registros relacionales a JSON
SELECT TOP 1
    id_donante,
    nombre,
    apellido,
    edad,
    tipoSangre,
    telefono
FROM Donante
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

SELECT TOP 1
    id_receptor,
    nombre,
    apellido,
    dni,
    telefono
FROM Receptor
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

SELECT *
FROM Transplante
FOR JSON PATH;

-------------------------------------------------------------------
             -- CREACION DE TABLA CON COLUMNA JSON
-------------------------------------------------------------------

DROP TABLE IF EXISTS Expediente_JSON;
GO

CREATE TABLE Expediente_JSON
(
    id_expediente INT IDENTITY(1,1) PRIMARY KEY,
    id_transplante INT NOT NULL,
    datos_json NVARCHAR(MAX) NOT NULL,
    fecha_registro DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT CK_Expediente_JSON_ISJSON CHECK (ISJSON(datos_json) > 0)
);
GO

-------------------------------------------------------------------
/* 3) INSERCION DE DATOS JSON DESDE LAS TABLAS DEL PROYECTO
Se arma un JSON completo con datos de:
- Transplante
- Donante
- Receptor
- Organo
- TipoOrgano
- Hospital
- Doctor */
-------------------------------------------------------------------

INSERT INTO Expediente_JSON (id_transplante, datos_json)
SELECT
    t.id_transplante,
    JSON_QUERY((
        SELECT
            t.id_transplante AS id_transplante,
            CONVERT(VARCHAR(10), t.fecha_trasplante, 120) AS fecha_trasplante,
            CASE t.estado
                WHEN 0 THEN 'En proceso'
                WHEN 1 THEN 'Finalizado'
                ELSE 'Sin estado'
            END AS estado,
            t.observacion AS observacion,

            JSON_QUERY((
                SELECT
                    d.id_donante,
                    d.nombre,
                    d.apellido,
                    d.edad,
                    d.genero,
                    d.peso,
                    d.patologia,
                    d.tipoSangre,
                    d.telefono
                FROM Donante d
                WHERE d.id_donante = t.id_donante
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS donante,

            JSON_QUERY((
                SELECT
                    r.id_receptor,
                    r.nombre,
                    r.apellido,
                    r.edad,
                    r.genero,
                    r.peso,
                    r.tipo_sangre,
                    r.telefono,
                    r.dni
                FROM Receptor r
                WHERE r.id_receptor = t.id_receptor
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS receptor,

            JSON_QUERY((
                SELECT
                    o.id_organo,
                    o.estado AS estado_organo,
                    tp.tipo AS tipo_organo
                FROM Organo o
                INNER JOIN TipoOrgano tp
                    ON o.id_tipoOrgano = tp.id_tipoOrgano
                WHERE o.id_organo = t.id_organo
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS organo,

            JSON_QUERY((
                SELECT
                    h.id_hospital,
                    h.nombre_hospital,
                    h.direccion
                FROM Hospital h
                WHERE h.id_hospital = t.id_hospital
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS hospital,

            JSON_QUERY((
                SELECT
                    doc.id_doctor,
                    doc.nombre,
                    doc.apellido,
                    doc.profesion,
                    doc.dni,
                    doc.telefono
                FROM Doctor doc
                WHERE doc.id_doctor = t.id_doctor
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS doctor

        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    )) AS datos_json
FROM Transplante t
INNER JOIN Donante d     ON t.id_donante = d.id_donante
INNER JOIN Receptor r    ON t.id_receptor = r.id_receptor
INNER JOIN Organo o      ON t.id_organo = o.id_organo
INNER JOIN TipoOrgano tp ON o.id_tipoOrgano = tp.id_tipoOrgano
INNER JOIN Hospital h    ON t.id_hospital = h.id_hospital
INNER JOIN Doctor doc    ON t.id_doctor = doc.id_doctor;
GO

-------------------------------------------------------------------
                    -- 4) CONSULTAS JSON
-------------------------------------------------------------------

-- Consultar campos puntuales del JSON
SELECT
    id_expediente,
    JSON_VALUE(datos_json, '$.estado') AS estado,
    JSON_VALUE(datos_json, '$.donante.nombre') AS nombre_donante,
    JSON_VALUE(datos_json, '$.donante.apellido') AS apellido_donante,
    JSON_VALUE(datos_json, '$.receptor.nombre') AS nombre_receptor,
    JSON_VALUE(datos_json, '$.organo.tipo_organo') AS tipo_organo,
    JSON_VALUE(datos_json, '$.hospital.nombre_hospital') AS hospital
FROM Expediente_JSON;

-- Consultar un objeto completo anidado
SELECT
    id_expediente,
    JSON_QUERY(datos_json, '$.donante') AS DonanteCompleto,
    JSON_QUERY(datos_json, '$.receptor') AS ReceptorCompleto
FROM Expediente_JSON;

-- Filtrar por un valor especifico del JSON
SELECT
    id_expediente,
    JSON_VALUE(datos_json, '$.donante.nombre') AS NombreDonante,
    JSON_VALUE(datos_json, '$.organo.tipo_organo') AS TipoOrgano
FROM Expediente_JSON
WHERE JSON_VALUE(datos_json, '$.organo.tipo_organo') = 'Rin';

-- Filtrar por estado del trasplante
SELECT
    id_expediente,
    JSON_VALUE(datos_json, '$.estado') AS Estado,
    JSON_VALUE(datos_json, '$.observacion') AS Observacion
FROM Expediente_JSON
WHERE JSON_VALUE(datos_json, '$.estado') = 'Finalizado';

-------------------------------------------------------------------
                   -- 5) MOSTRAR JSON EN FILAS
-------------------------------------------------------------------

-- Muestra el JSON como pares clave/valor
SELECT
    e.id_expediente,
    j.[key] AS Clave,
    j.[value] AS Valor
FROM Expediente_JSON e
CROSS APPLY OPENJSON(e.datos_json) AS j;

-- Mapea campos anidados en columnas
SELECT
    e.id_expediente,
    x.nombre_donante,
    x.apellido_donante,
    x.tipo_organo,
    x.nombre_hospital,
    x.estado
FROM Expediente_JSON e
CROSS APPLY OPENJSON(e.datos_json)
WITH
(
    nombre_donante NVARCHAR(50) '$.donante.nombre',
    apellido_donante NVARCHAR(50) '$.donante.apellido',
    tipo_organo NVARCHAR(50) '$.organo.tipo_organo',
    nombre_hospital NVARCHAR(100) '$.hospital.nombre_hospital',
    estado NVARCHAR(20) '$.estado'
) AS x;

-------------------------------------------------------------------
                -- 6) ACTUALIZACION DE DATOS JSON
-------------------------------------------------------------------

-- Actualizar un valor dentro del JSON
UPDATE Expediente_JSON
SET datos_json = JSON_MODIFY(datos_json, '$.observacion', 'Paciente estable luego de la cirugia')
WHERE id_transplante = 4;

-- Agregar un nuevo atributo JSON
UPDATE Expediente_JSON
SET datos_json = JSON_MODIFY(datos_json, '$.seguimiento', 'Control postoperatorio en 48 horas')
WHERE id_transplante = 4;

-- Agregar un dato al objeto anidado
UPDATE Expediente_JSON
SET datos_json = JSON_MODIFY(datos_json, '$.hospital.telefono', '3794555555')
WHERE id_transplante = 1;

-------------------------------------------------------------------
            -- 7) ELIMINAR REGISTROS BASADOS EN JSON
-------------------------------------------------------------------

-- Eliminar registros que tengan estado "En proceso"
DELETE FROM Expediente_JSON
WHERE JSON_VALUE(datos_json, '$.estado') = 'En proceso';

-------------------------------------------------------------------
           -- 8) OPTIMIZACION DE CONSULTAS JSON
-------------------------------------------------------------------

-- Columnas calculadas para evitar leer el JSON repetidamente
ALTER TABLE Expediente_JSON
ADD
    estado_json AS LEFT(JSON_VALUE(datos_json, '$.estado'), 20) PERSISTED,
    tipo_organo_json AS LEFT(JSON_VALUE(datos_json, '$.organo.tipo_organo'), 50) PERSISTED,
    nombre_donante_json AS LEFT(JSON_VALUE(datos_json, '$.donante.nombre'), 50) PERSISTED;
GO

-- Indice sobre columnas calculadas
CREATE INDEX IX_Expediente_JSON_Tipo_Estado
ON Expediente_JSON (tipo_organo_json, estado_json)
INCLUDE (nombre_donante_json);
GO

-- Consulta optimizada usando columnas calculadas
SELECT
    id_expediente,
    nombre_donante_json AS nombre_donante,
    tipo_organo_json AS tipo_organo,
    estado_json AS estado
FROM Expediente_JSON
WHERE tipo_organo_json = 'Rin'
AND estado_json = 'Finalizado';

-------------------------------------------------------------------
           -- 9) CONSULTA FINAL Y VERIFICACION
-------------------------------------------------------------------

SELECT *
FROM Expediente_JSON;

-- Exportar toda la tabla JSON
SELECT *
FROM Expediente_JSON
FOR JSON PATH;