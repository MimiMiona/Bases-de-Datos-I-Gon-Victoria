-------------------------------------------------------------------
          -- TEMA 2: PROCEDIMIENTOS Y FUNCIONES ALMACENADAS
-------------------------------------------------------------------

-------------------------------------------------------------------
         -- PROCEDIMIENTO 1 - INSERTAR DONANTE
-------------------------------------------------------------------

CREATE PROCEDURE spInsertarDonante
    @id_donante INT,
    @nombre VARCHAR(50),
    @apellido VARCHAR(50),
    @edad INT,
    @genero VARCHAR(20),
    @peso FLOAT,
    @patologia VARCHAR(100),
    @tipoSangre VARCHAR(5),
    @telefono VARCHAR(20),
    @contraseña VARCHAR(50)
AS
BEGIN

    INSERT INTO Donante
    (
        id_donante,
        nombre,
        apellido,
        edad,
        genero,
        peso,
        patologia,
        tipoSangre,
        telefono,
        contraseña
    )
    VALUES
    (
        @id_donante,
        @nombre,
        @apellido,
        @edad,
        @genero,
        @peso,
        @patologia,
        @tipoSangre,
        @telefono,
        @contraseña
    );

    PRINT 'Donante insertado correctamente';

END;
GO

-------------------------------------------------------------------
   -- PROCEDIMIENTO 2 - ACTUALIZAR ESTADO DEL ORGANO
-------------------------------------------------------------------

CREATE PROCEDURE spActualizarEstadoOrgano
    @id_organo INT,
    @nuevoEstado VARCHAR(30)
AS
BEGIN

    UPDATE Organo
    SET estado = @nuevoEstado
    WHERE id_organo = @id_organo;

    PRINT 'Estado del órgano actualizado';

END;
GO

-------------------------------------------------------------------
          -- PROCEDIMIENTO 3 - ELIMINAR HOSPITAL
-------------------------------------------------------------------

CREATE PROCEDURE spEliminarHospital
    @id_hospital INT
AS
BEGIN

    DELETE FROM Hospital
    WHERE id_hospital = @id_hospital;

    PRINT 'Hospital eliminado correctamente';

END;
GO

-------------------------------------------------------------------
                    -- FUNCIONES
-------------------------------------------------------------------

-------------------------------------------------------------------
      -- FUNCIÓN 1 - CANTIDAD DE ÓRGANOS DISPONIBLES
-------------------------------------------------------------------

CREATE FUNCTION fnCantidadOrganosDisponibles()
RETURNS INT
AS
BEGIN

    DECLARE @cantidad INT;

    SELECT @cantidad = COUNT(*)
    FROM Organo
    WHERE estado = 'Disponible';

    RETURN @cantidad;

END;
GO

-------------------------------------------------------------------
           -- FUNCIÓN 2 - ÓRGANOS SEGÚN EL TIPO
-------------------------------------------------------------------

CREATE FUNCTION fnOrganosPorTipo
(
    @tipo VARCHAR(40)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        o.id_organo,
        o.estado,
        d.nombre,
        d.apellido
    FROM Organo o
        INNER JOIN Donante d
            ON o.id_donante = d.id_donante
        INNER JOIN TipoOrgano t
            ON o.id_tipoOrgano = t.id_tipoOrgano
    WHERE t.tipo = @tipo
);
GO

-------------------------------------------------------------------
      -- FUNCIÓN 3 - NOMBRE COMPLETO DEL DONANTE
-------------------------------------------------------------------

CREATE FUNCTION fnNombreCompletoDonante
(
    @id_donante INT
)
RETURNS VARCHAR(120)
AS
BEGIN

    DECLARE @nombreCompleto VARCHAR(120);

    SELECT
        @nombreCompleto = nombre + ' ' + apellido
    FROM Donante
    WHERE id_donante = @id_donante;

    RETURN @nombreCompleto;

END;
GO

-------------------------------------------------------------------
              -- EJECUCIÓN DE PROCEDIMIENTOS
-------------------------------------------------------------------

-- Insertar un donante
EXEC spInsertarDonante
11,
'Carlos',
'Lopez',
35,
'Masculino',
82,
'Ninguna',
'O+',
'3794143456',
'1234';


-- Actualizar estado de un órgano
EXEC spActualizarEstadoOrgano
1,
'Asignado';

-- Eliminar un hospital
EXEC spEliminarHospital 8;

-------------------------------------------------------------------
               -- EJECUCIÓN DE FUNCIONES
-------------------------------------------------------------------

-- Cantidad de órganos disponibles
SELECT dbo.fnCantidadOrganosDisponibles()
AS OrganosDisponibles;


-- Listar órganos por tipo
SELECT *
FROM fnOrganosPorTipo('Riñón');


-- Obtener nombre completo del donante
SELECT dbo.fnNombreCompletoDonante(1)
AS Donante;