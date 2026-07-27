-------------------------------------------------------------------
    -- TEMA 1: MANEJO DE PERMISOS A NIVEL DE USUARIOS
-------------------------------------------------------------------

USE Ley_Justina;
GO
-------------------------------------------------------------------
            -- 1. MANEJO DE PERMISOS A NIVEL DE USUARIOS
-------------------------------------------------------------------

-------------------------------------------------------------------
           -- 1.1 Creación de Usuario Administrador
-------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'UsuarioAdmin')
    CREATE LOGIN UsuarioAdmin
    WITH PASSWORD = 'Admin123$';
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'UsuarioAdmin')
    CREATE USER UsuarioAdmin
    FOR LOGIN UsuarioAdmin;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_role_members drm
    INNER JOIN sys.database_principals dp ON drm.member_principal_id = dp.principal_id
    INNER JOIN sys.database_principals rp ON drm.role_principal_id = rp.principal_id
    WHERE dp.name = 'UsuarioAdmin'
      AND rp.name = 'db_owner'
)
BEGIN
    ALTER ROLE db_owner
    ADD MEMBER UsuarioAdmin;
END
GO

-------------------------------------------------------------------
        -- 1.2 Creación de Usuario Médico (Solo Lectura)
-------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'UsuarioMedico')
    CREATE LOGIN UsuarioMedico
    WITH PASSWORD = 'Medico123$';
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'UsuarioMedico')
    CREATE USER UsuarioMedico
    FOR LOGIN UsuarioMedico;
GO

GRANT SELECT ON dbo.Donante TO UsuarioMedico;
GRANT SELECT ON dbo.Receptor TO UsuarioMedico;
GRANT SELECT ON dbo.Organo TO UsuarioMedico;
GRANT SELECT ON dbo.Hospital TO UsuarioMedico;
GO

-------------------------------------------------------------------
              -- 2. PROCEDIMIENTO ALMACENADO
-------------------------------------------------------------------

CREATE OR ALTER PROCEDURE dbo.insertarTransplante
    @id_transplante INT,
    @fecha_trasplante DATE,
    @estado VARCHAR(30),
    @observacion VARCHAR(100),
    @id_organo INT,
    @id_hospital INT,
    @id_doctor INT,
    @id_receptor INT
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Transplante
    (
        id_transplante,
        fecha_trasplante,
        estado,
        observacion,
        id_organo,
        id_hospital,
        id_doctor,
        id_receptor
    )
    VALUES
    (
        @id_transplante,
        @fecha_trasplante,
        @estado,
        @observacion,
        @id_organo,
        @id_hospital,
        @id_doctor,
        @id_receptor
    );
END;
GO

GRANT EXECUTE
ON dbo.insertarTransplante
TO UsuarioMedico;
GO

-------------------------------------------------------------------
                           -- PRUEBA 1
    -- UsuarioMedico intenta insertar directamente (Sin permiso)
-------------------------------------------------------------------

BEGIN TRY
    EXECUTE AS USER = 'UsuarioMedico';

    INSERT INTO dbo.Transplante
    VALUES
    (
        (SELECT ISNULL(MAX(id_transplante),0)+1 FROM dbo.Transplante),
        '2026-07-20',
        'Programado',
        'Prueba',
        1,
        1,
        1,
        1
    );

    REVERT;
END TRY
BEGIN CATCH
    PRINT 'Prueba 1: inserción directa bloqueada correctamente.';
    PRINT ERROR_MESSAGE();

    IF USER_NAME() = 'UsuarioMedico'
        REVERT;
END CATCH
GO

-------------------------------------------------------------------
                            -- PRUEBA 2
 -- UsuarioMedico utiliza el procedimiento almacenado (Con permiso)
-------------------------------------------------------------------

DECLARE @NuevoIdTransplante INT;

SELECT @NuevoIdTransplante = ISNULL(MAX(id_transplante), 0) + 1
FROM dbo.Transplante;

EXECUTE AS USER = 'UsuarioMedico';

EXEC dbo.insertarTransplante
    @NuevoIdTransplante,
    '2026-07-20',
    'En Proceso',
    'Trasplante realizado correctamente',
    1,
    1,
    1,
    1;

REVERT;
GO

SELECT *
FROM dbo.Transplante
WHERE id_transplante = (SELECT MAX(id_transplante) FROM dbo.Transplante);
GO

-------------------------------------------------------------------
            -- 3. MANEJO DE PERMISOS MEDIANTE ROLES
-------------------------------------------------------------------

-------------------------------------------------------------------
                         -- Creación del Rol
-------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'RolConsulta' AND type = 'R')
    CREATE ROLE RolConsulta;
GO

GRANT SELECT ON dbo.Donante TO RolConsulta;
GRANT SELECT ON dbo.Receptor TO RolConsulta;
GRANT SELECT ON dbo.Organo TO RolConsulta;
GO

-------------------------------------------------------------------
                        -- Creación de Usuarios
-------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'UsuarioRol1')
    CREATE LOGIN UsuarioRol1
    WITH PASSWORD = 'Rol123$';
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'UsuarioRol1')
    CREATE USER UsuarioRol1
    FOR LOGIN UsuarioRol1;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_role_members drm
    INNER JOIN sys.database_principals dp ON drm.member_principal_id = dp.principal_id
    INNER JOIN sys.database_principals rp ON drm.role_principal_id = rp.principal_id
    WHERE dp.name = 'UsuarioRol1'
      AND rp.name = 'RolConsulta'
)
BEGIN
    ALTER ROLE RolConsulta
    ADD MEMBER UsuarioRol1;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'UsuarioRol2')
    CREATE LOGIN UsuarioRol2
    WITH PASSWORD = 'Rol456$';
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'UsuarioRol2')
    CREATE USER UsuarioRol2
    FOR LOGIN UsuarioRol2;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_role_members drm
    INNER JOIN sys.database_principals dp ON drm.member_principal_id = dp.principal_id
    INNER JOIN sys.database_principals rp ON drm.role_principal_id = rp.principal_id
    WHERE dp.name = 'UsuarioRol2'
      AND rp.name = 'RolConsulta'
)
BEGIN
    ALTER ROLE RolConsulta
    ADD MEMBER UsuarioRol2;
END
GO

-------------------------------------------------------------------
                    -- PRUEBA UsuarioRol1
-------------------------------------------------------------------

EXECUTE AS USER = 'UsuarioRol1';

SELECT * FROM dbo.Donante;
SELECT * FROM dbo.Receptor;
SELECT * FROM dbo.Organo;

REVERT;
GO

-------------------------------------------------------------------
                    -- PRUEBA UsuarioRol2
-------------------------------------------------------------------

EXECUTE AS USER = 'UsuarioRol2';

SELECT * FROM dbo.Donante;

REVERT;
GO