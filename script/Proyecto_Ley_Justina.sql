CREATE DATABASE Ley_Justina;
GO

USE Ley_Justina;
GO

-- ==========================================
-- TABLA DONANTE
-- ==========================================

CREATE TABLE Donante
(
    id_donante INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INT NOT NULL,
    genero VARCHAR(20) NOT NULL,
    peso FLOAT NOT NULL,
    patologia VARCHAR(100) NOT NULL,
    tipoSangre VARCHAR(5) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    contraseña VARCHAR(50) NOT NULL,

    CONSTRAINT PK_DONANTE PRIMARY KEY(id_donante),
    CONSTRAINT UQ_DONANTE_TELEFONO UNIQUE(telefono),
    CONSTRAINT CK_DONANTE_EDAD CHECK(edad >= 18),
    CONSTRAINT CK_DONANTE_PESO CHECK(peso > 0),
    CONSTRAINT CK_DONANTE_GENERO CHECK(genero IN ('Masculino','Femenino','Otro')),
    CONSTRAINT CK_DONANTE_TIPO_SANGRE CHECK(tipoSangre IN ('A+','A-','B+','B-','AB+','AB-','O+','O-'))
);
-- ==========================================
-- TABLA TIPO ORGANO
-- ==========================================

CREATE TABLE TipoOrgano
(
    id_tipoOrgano INT NOT NULL,
    tipo VARCHAR(40) NOT NULL,

    CONSTRAINT PK_TIPO_ORGANO PRIMARY KEY(id_tipoOrgano),
    CONSTRAINT UQ_TIPO_ORGANO UNIQUE(tipo)
);
-- ==========================================
-- TABLA ORGANO
-- ==========================================

CREATE TABLE Organo
(
    id_organo INT NOT NULL,
    estado VARCHAR(30) NOT NULL,
    id_donante INT NOT NULL,
    id_tipoOrgano INT NOT NULL,

    CONSTRAINT PK_ORGANO PRIMARY KEY(id_organo),
    CONSTRAINT FK_ORGANO_DONANTE FOREIGN KEY(id_donante) REFERENCES Donante(id_donante),
    CONSTRAINT FK_ORGANO_TIPO FOREIGN KEY(id_tipoOrgano) REFERENCES TipoOrgano(id_tipoOrgano),
    CONSTRAINT CK_ESTADO_ORGANO CHECK(estado IN ('Disponible','Asignado','Trasplantado','Descartado'))
);

-- ==========================================
-- TABLA RECEPTOR
-- ==========================================

CREATE TABLE Receptor
(
    id_receptor INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INT NOT NULL,
    genero VARCHAR(20) NOT NULL,
    peso FLOAT NOT NULL,
    tipo_sangre VARCHAR(5) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    dni INT NOT NULL,
    contraseña VARCHAR(50) NOT NULL,
    id_organo INT NOT NULL,

    CONSTRAINT PK_RECEPTOR PRIMARY KEY(id_receptor),
    CONSTRAINT UQ_RECEPTOR_DNI UNIQUE(dni),
    CONSTRAINT UQ_RECEPTOR_TELEFONO UNIQUE(telefono),
    CONSTRAINT CK_RECEPTOR_EDAD CHECK(edad > 0),
    CONSTRAINT CK_RECEPTOR_PESO CHECK(peso > 0),
    CONSTRAINT CK_RECEPTOR_GENERO CHECK(genero IN ('Masculino','Femenino','Otro')),
    CONSTRAINT CK_RECEPTOR_SANGRE CHECK(tipo_sangre IN ('A+','A-','B+','B-','AB+','AB-','O+','O-'))
);


-- ==========================================
-- TABLA HOSPITAL
-- ==========================================

CREATE TABLE Hospital
(
    id_hospital INT NOT NULL,
    nombre_hospital VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,

    CONSTRAINT PK_HOSPITAL PRIMARY KEY(id_hospital),
    CONSTRAINT UQ_HOSPITAL UNIQUE(nombre_hospital)
);
-- ==========================================
-- TABLA DOCTOR
-- ==========================================

CREATE TABLE Doctor
(
    id_doctor INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    profesion VARCHAR(50) NOT NULL,
    dni INT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    contraseña VARCHAR(50) NOT NULL,
    id_hospital INT NOT NULL,

    CONSTRAINT PK_DOCTOR PRIMARY KEY(id_doctor),
    CONSTRAINT FK_DOCTOR_HOSPITAL FOREIGN KEY(id_hospital) REFERENCES Hospital(id_hospital),
    CONSTRAINT UQ_DOCTOR_DNI UNIQUE(dni),
    CONSTRAINT UQ_DOCTOR_TELEFONO UNIQUE(telefono)
);


-- ==========================================
-- TABLA ADMINISTRATIVO
-- ==========================================

CREATE TABLE Administrativo
(
    id_administrativo INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    numero_legajo INT NOT NULL,
    dni INT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    contraseña VARCHAR(50) NOT NULL,
    id_hospital INT NOT NULL,

    CONSTRAINT PK_ID_ADMINISTRATIVO PRIMARY KEY(id_administrativo),
    CONSTRAINT FK_ADMINISTRATIVO_HOSPITAL FOREIGN KEY(id_hospital) REFERENCES Hospital(id_hospital),
    CONSTRAINT UQ_ADMINISTRATIVO_DNI UNIQUE(dni),
    CONSTRAINT UQ_ADMINISTRATIVO_LEGAJO UNIQUE(numero_legajo),
    CONSTRAINT UQ_ADMINISTRATIVO_TELEFONO UNIQUE(telefono)
);

-- ==========================================
-- TABLA ASIGNACION
-- ==========================================

CREATE TABLE Asignacion
(
  id_asignacion INT NOT NULL,
  fecha_asignacion DATE NOT NULL,
  estado INT NOT NULL,
  observacion VARCHAR(100) NOT NULL,
  id_organo INT NOT NULL,
  id_receptor INT NOT NULL,
  CONSTRAINT PK_ID_ASIGNACION PRIMARY KEY (id_asignacion),
  CONSTRAINT FK_ID_ASIGNACION_ORGANO FOREIGN KEY (id_organo) REFERENCES Organo(id_organo),
  CONSTRAINT FK_ASIGNACION_RECEPTOR FOREIGN KEY (id_receptor) REFERENCES Receptor(id_receptor)
);

-- ==========================================
-- TABLA LISTA ESPERA
-- ==========================================

CREATE TABLE ListaEspera
(
  id_lista INT NOT NULL,
  fecha_ingreso DATE NOT NULL,
  fecha_baja DATE NOT NULL,
  estado INT NOT NULL,
  prioridad INT NOT NULL,
  id_receptor INT NOT NULL,
  id_tipoOrgano INT NOT NULL,
  id_asignacion INT NOT NULL,
  CONSTRAINT PK_ID_LISTA PRIMARY KEY (id_lista), 
  CONSTRAINT FK_ID_LISTA_RECEPTOR FOREIGN KEY (id_receptor) REFERENCES Receptor(id_receptor),
  CONSTRAINT FK_ID_LISTA_TIPO_ORGANO FOREIGN KEY (id_tipoOrgano) REFERENCES TipoOrgano(id_tipoOrgano),
  CONSTRAINT FK_ID_LISTA_ASIGNACION FOREIGN KEY (id_asignacion) REFERENCES Asignacion(id_asignacion)
);

-- ==========================================
-- TABLA TRANSPLANTE
-- ==========================================

CREATE TABLE Transplante
(
  id_transplante INT NOT NULL,
  fecha_trasplante DATE NOT NULL,
  estado INT NOT NULL,
  observacion VARCHAR(100) NOT NULL,
  id_organo INT NOT NULL,
  id_donante INT NOT NULL,
  id_hospital INT NOT NULL,
  id_doctor INT NOT NULL,
  id_receptor INT NOT NULL,
  CONSTRAINT PK_ID_TRANSPLANTE PRIMARY KEY (id_transplante), 
  CONSTRAINT FK_ID_TRANSPLANTE_ORGANO FOREIGN KEY (id_organo) REFERENCES Organo(id_organo),
  CONSTRAINT FK_ID_TRANSPLANTE_DONANTE FOREIGN KEY (id_donante) REFERENCES Donante(id_donante),
  CONSTRAINT FK_ID_TRANSPLANTE_HOSPITAL FOREIGN KEY (id_hospital) REFERENCES Hospital(id_hospital),
  CONSTRAINT FK_ID_TRANSPLANTE_DOCTOR FOREIGN KEY (id_doctor) REFERENCES Doctor(id_doctor),
  CONSTRAINT FK_ID_TRANSPLANTE_RECEPTOR FOREIGN KEY (id_receptor) REFERENCES Receptor(id_receptor),
);