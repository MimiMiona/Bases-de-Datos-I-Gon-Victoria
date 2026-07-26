-------------------------------------------------------------------
    -- Manejo de permisos a nivel de usuarios de base de datos
-------------------------------------------------------------------

-------------------------------------------------------------------
                        -- BASE DE DATOS
-------------------------------------------------------------------

USE Ley_Justina;

GO

-------------------------------------------------------------------
           -- 1. MANEJO DE PERMISOS A NIVEL DE USUARIOS
-------------------------------------------------------------------

-------------------------------------------------------------------
           -- 1.1 Creación de Usuario Administrador
-------------------------------------------------------------------

CREATE LOGIN UsuarioAdmin
WITH PASSWORD = 'Admin123$';

CREATE USER UsuarioAdmin
FOR LOGIN UsuarioAdmin;

ALTER ROLE db_owner
ADD MEMBER UsuarioAdmin;

-------------------------------------------------------------------
           -- 1.2 Creación de Usuario Médico (Solo Lectura)
-------------------------------------------------------------------

CREATE LOGIN UsuarioMedico
WITH PASSWORD = 'Medico123$';

CREATE USER UsuarioMedico
FOR LOGIN UsuarioMedico;

GRANT SELECT ON Donante TO UsuarioMedico;
GRANT SELECT ON Receptor TO UsuarioMedico;
GRANT SELECT ON Organo TO UsuarioMedico;
GRANT SELECT ON Hospital TO UsuarioMedico;

-------------------------------------------------------------------
           -- 2. PERMISOS SOBRE PROCEDIMIENTOS ALMACENADOS
-------------------------------------------------------------------

-- Permitir ejecutar el procedimiento almacenado
GRANT EXECUTE
ON insertarTransplante
TO UsuarioMedico;

-------------------------------------------------------------------
                           -- PRUEBA 1
 -- UsuarioMedico intenta insertar directamente (NO DEBE PERMITIR)
-------------------------------------------------------------------

EXECUTE AS USER = 'UsuarioMedico';

INSERT INTO Transplante
VALUES
(
6,
'2026-07-20',
1,
'Prueba',
1,
1,
1,
1,
1
);

REVERT;

-------------------------------------------------------------------
                            -- PRUEBA 2
 -- UsuarioMedico utiliza el procedimiento almacenado (SI DEBE PERMITIR)
-------------------------------------------------------------------

EXECUTE AS USER = 'UsuarioMedico';

EXEC insertarTransplante
6,
'2026-07-20',
1,
'Trasplante realizado correctamente',
1,
1,
1,
1,
1;

SELECT * FROM Transplante;

REVERT;

-------------------------------------------------------------------
            -- 3. MANEJO DE PERMISOS MEDIANTE ROLES
-------------------------------------------------------------------

-------------------------------------------------------------------
                     -- Creación del Rol
-------------------------------------------------------------------

CREATE ROLE RolConsulta;

GRANT SELECT ON Donante TO RolConsulta;
GRANT SELECT ON Receptor TO RolConsulta;
GRANT SELECT ON Organo TO RolConsulta;

-------------------------------------------------------------------
                    -- Creación de Usuarios
-------------------------------------------------------------------

CREATE LOGIN UsuarioRol1
WITH PASSWORD='Rol123$';

CREATE USER UsuarioRol1
FOR LOGIN UsuarioRol1;

ALTER ROLE RolConsulta
ADD MEMBER UsuarioRol1;


CREATE LOGIN UsuarioRol2
WITH PASSWORD='Rol456$';

CREATE USER UsuarioRol2
FOR LOGIN UsuarioRol2;

-------------------------------------------------------------------
                       -- PRUEBA UsuarioRol1
-------------------------------------------------------------------

EXECUTE AS USER='UsuarioRol1';

SELECT * FROM Donante;
SELECT * FROM Receptor;
SELECT * FROM Organo;

REVERT;

-------------------------------------------------------------------
                       -- PRUEBA UsuarioRol2
-------------------------------------------------------------------

EXECUTE AS USER='UsuarioRol2';

SELECT * FROM Donante;

REVERT;