/*====================================================
    LOTE DE DATOS - LEY JUSTINA
====================================================*/

USE Ley_Justina;
GO

/*====================================================
    TABLA DONANTE
====================================================*/

INSERT INTO Donante
(id_donante, nombre, apellido, edad, genero, peso, patologia, tipoSangre, telefono, contraseña)
VALUES
(1, 'Juan', 'Pérez', 35, 'Masculino', 78, 'Ninguna', 'O+', '3794000001', 'juan123'),
(2, 'María', 'Gómez', 42, 'Femenino', 62, 'Ninguna', 'A+', '3794000002', 'maria123'),
(3, 'Carlos', 'Fernández', 29, 'Masculino', 85, 'Ninguna', 'B+', '3794000003', 'carlos123'),
(4, 'Lucía', 'Benítez', 31, 'Femenino', 59, 'Ninguna', 'AB+', '3794000004', 'lucia123'),
(5, 'Pedro', 'Martínez', 48, 'Masculino', 90, 'Hipertensión', 'O-', '3794000005', 'pedro123');

SELECT * FROM Donante;


/*====================================================
    TABLA TIPO ORGANO
====================================================*/

INSERT INTO TipoOrgano
(id_tipoOrgano, tipo)
VALUES
(1, 'Riñón'),
(2, 'Hígado'),
(3, 'Corazón'),
(4, 'Pulmón'),
(5, 'Páncreas');

SELECT * FROM TipoOrgano;


/*====================================================
    TABLA ORGANO
====================================================*/

INSERT INTO Organo
(id_organo, estado, id_donante, id_tipoOrgano)
VALUES
(1, 'Disponible',   1, 1),
(2, 'Asignado',     2, 2),
(3, 'Trasplantado', 3, 3),
(4, 'Disponible',   4, 4),
(5, 'Disponible',   5, 5);

SELECT * FROM Organo;

/*====================================================
    TABLA RECEPTOR
====================================================*/

INSERT INTO Receptor
(id_receptor, nombre, apellido, edad, genero, peso, tipo_sangre, telefono, dni, contraseña, id_organo)
VALUES
(1, 'Ana', 'López', 26, 'Femenino', 58, 'O+', '3794111111', 40111222, 'ana123', 1),
(2, 'Martín', 'Sosa', 45, 'Masculino', 84, 'A+', '3794111112', 32222333, 'martin123', 2),
(3, 'Valentina', 'Ríos', 18, 'Femenino', 55, 'B+', '3794111113', 45111444, 'vale123', 3),
(4, 'Diego', 'Romero', 51, 'Masculino', 81, 'AB+', '3794111114', 28111555, 'diego123', 4),
(5, 'Camila', 'Acosta', 37, 'Femenino', 64, 'O-', '3794111115', 35111666, 'camila123', 5);

SELECT * FROM Receptor;


/*====================================================
    TABLA HOSPITAL
====================================================*/

INSERT INTO Hospital
(id_hospital, nombre_hospital, direccion)
VALUES
(1, 'Hospital Escuela José F. de San Martín', 'Córdoba 1000'),
(2, 'Hospital Perrando', 'Av. 9 de Julio 1100'),
(3, 'Hospital Pediátrico Juan Pablo II', 'Suipacha 1800'),
(4, 'Hospital Vidal', 'Av. Independencia 2500'),
(5, 'Hospital Italiano', 'Buenos Aires 500');

SELECT * FROM Hospital;


/*====================================================
    TABLA DOCTOR
====================================================*/

INSERT INTO Doctor
(id_doctor, nombre, apellido, profesion, dni, telefono, contraseña, id_hospital)
VALUES
(1, 'Fernando', 'Ruiz', 'Cirujano', 30111222, '3794222221', 'doc123', 1),
(2, 'Laura', 'Giménez', 'Cirujana', 31111333, '3794222222', 'doc123', 2),
(3, 'Miguel', 'Silva', 'Cardiólogo', 32111444, '3794222223', 'doc123', 3),
(4, 'Paula', 'Molina', 'Nefróloga', 33111555, '3794222224', 'doc123', 4),
(5, 'Ricardo', 'Vega', 'Cirujano', 34111666, '3794222225', 'doc123', 5);

SELECT * FROM Doctor;


/*====================================================
    TABLA ADMINISTRATIVO
====================================================*/

INSERT INTO Administrativo
(id_administrativo, nombre, apellido, numero_legajo, dni, telefono, contraseña, id_hospital)
VALUES
(1, 'Julieta', 'Luna', 1001, 37111222, '3794333331', 'admin123', 1),
(2, 'Tomás', 'Alvarez', 1002, 38111333, '3794333332', 'admin123', 2),
(3, 'Florencia', 'Castro', 1003, 39111444, '3794333333', 'admin123', 3),
(4, 'Gabriel', 'Moreno', 1004, 40111555, '3794333334', 'admin123', 4),
(5, 'Sofía', 'Ramos', 1005, 41111666, '3794333335', 'admin123', 5);

SELECT * FROM Administrativo;


/*====================================================
    TABLA ASIGNACION
====================================================*/

/*
Estado:
1 = Asignada
2 = Completada
*/

INSERT INTO Asignacion
(id_asignacion, fecha_asignacion, estado, observacion, id_organo, id_receptor)
VALUES
(1, '2026-05-10', 1, 'Asignación realizada', 1, 1),
(2, '2026-05-15', 1, 'Asignación realizada', 2, 2),
(3, '2026-05-20', 2, 'Trasplante realizado', 3, 3),
(4, '2026-06-01', 1, 'Pendiente de cirugía', 4, 4),
(5, '2026-06-05', 1, 'Pendiente de cirugía', 5, 5);

SELECT * FROM Asignacion;


/*====================================================
    TABLA LISTA ESPERA
====================================================*/

/*
Estado:
1 = Activo
2 = Finalizado

Prioridad:
1 = Alta
2 = Media
3 = Baja
*/

INSERT INTO ListaEspera
(id_lista, fecha_ingreso, fecha_baja, estado, prioridad, id_receptor, id_tipoOrgano, id_asignacion)
VALUES
(1, '2026-03-01', '2026-05-10', 1, 1, 1, 1, 1),
(2, '2026-03-05', '2026-05-15', 1, 2, 2, 2, 2),
(3, '2026-03-10', '2026-05-20', 2, 1, 3, 3, 3),
(4, '2026-04-01', '2026-06-01', 1, 3, 4, 4, 4),
(5, '2026-04-10', '2026-06-05', 1, 2, 5, 5, 5);

SELECT * FROM ListaEspera;


/*====================================================
    TABLA TRANSPLANTE
====================================================*/

/*
Estado:
0 = En proceso
1 = Finalizado
*/

INSERT INTO Transplante
(id_transplante, fecha_trasplante, estado, observacion, id_organo, id_donante, id_hospital, id_doctor, id_receptor)
VALUES
(1, '2026-05-11', 1, 'Trasplante exitoso', 1, 1, 1, 1, 1),
(2, '2026-05-16', 1, 'Paciente estable', 2, 2, 2, 2, 2),
(3, '2026-05-21', 1, 'Recuperación favorable', 3, 3, 3, 3, 3),
(4, '2026-06-02', 0, 'En observación', 4, 4, 4, 4, 4),
(5, '2026-06-06', 0, 'Postoperatorio', 5, 5, 5, 5, 5);

SELECT * FROM Transplante;