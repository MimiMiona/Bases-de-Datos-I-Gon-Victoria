# TEMA 1: Manejo de Permisos a Nivel de Usuarios de Base de Datos

### Introducción

La seguridad constituye uno de los aspectos más importantes dentro de un Sistema Gestor de Bases de Datos (SGBD). En SQL Server, el control de acceso se realiza mediante la asignación de permisos a usuarios y roles, permitiendo definir qué operaciones puede ejecutar cada persona sobre los distintos objetos almacenados en la base de datos.

Una correcta administración de permisos garantiza la confidencialidad, integridad y disponibilidad de la información, evitando accesos no autorizados y reduciendo el riesgo de modificaciones accidentales o malintencionadas. Por este motivo, SQL Server incorpora mecanismos que permiten administrar usuarios individuales, agrupar permisos mediante roles y controlar el acceso a procedimientos almacenados y demás objetos de la base de datos.

En el desarrollo del proyecto **Ley_Justina**, estos mecanismos fueron implementados para proteger la información relacionada con donantes, receptores, órganos, hospitales y procedimientos de trasplante, asignando distintos niveles de acceso según las responsabilidades de cada usuario.

#### Permisos en SQL Server

Los permisos permiten controlar las acciones que un usuario puede realizar sobre los distintos objetos de una base de datos, como tablas, vistas, procedimientos almacenados, funciones y esquemas.
Dependiendo del tipo de operación que se desee autorizar, SQL Server ofrece diferentes clases de permisos.
#### Permisos DML (Data Manipulation Language)

Corresponden a las operaciones de manipulación de datos almacenados dentro de las tablas.

- **SELECT:** permite consultar información.
- **INSERT:** permite agregar nuevos registros.
- **UPDATE:** permite modificar registros existentes.
- **DELETE:** permite eliminar registros.

#### Permisos de Ejecución

Permiten ejecutar procedimientos almacenados y funciones sin necesidad de otorgar acceso directo a las tablas involucradas.

- **EXECUTE:** autoriza la ejecución de procedimientos almacenados.


#### Permisos de Administración

Estos permisos permiten administrar o modificar la estructura de los objetos de la base de datos.

- **ALTER:** permite modificar la estructura de un objeto.
- **CONTROL:** concede control total sobre un objeto determinado.


### Usuarios en SQL Server

SQL Server diferencia la autenticación del servidor de la autenticación dentro de una base de datos.

Para que una persona pueda acceder a una base determinada es necesario crear, en primer lugar, un **LOGIN** a nivel del servidor y posteriormente asociarlo a un **USER** dentro de la base de datos correspondiente.

La creación de un usuario generalmente se realiza mediante las siguientes instrucciones:

```sql
CREATE LOGIN UsuarioEjemplo
WITH PASSWORD = 'Password123';

USE Ley_Justina;

CREATE USER UsuarioEjemplo
FOR LOGIN UsuarioEjemplo;
```

Una vez creado el usuario, es posible asignarle permisos específicos mediante diferentes instrucciones.

Los comandos más utilizados para administrar permisos son:

- **GRANT:** concede permisos.
- **DENY:** niega un permiso, incluso cuando pudiera heredarse por otro rol.
- **REVOKE:** elimina permisos previamente asignados.

#### Ejemplo

```sql
GRANT SELECT ON Donante TO UsuarioMedico;

DENY DELETE ON Donante TO UsuarioMedico;

GRANT EXECUTE ON insertarTransplante TO UsuarioMedico;
```

### Roles en SQL Server

Los roles permiten agrupar permisos para administrarlos de forma centralizada. En lugar de asignar permisos individualmente a cada usuario, estos se otorgan al rol y posteriormente se agregan los usuarios que lo utilizarán.

SQL Server dispone de distintos roles predefinidos, entre los cuales se destacan:

- **db_owner:** posee control total sobre la base de datos.
- **db_datareader:** permite consultar todas las tablas.
- **db_datawriter:** permite insertar, modificar y eliminar registros.

Además, es posible crear roles personalizados para adaptarlos a las necesidades particulares de cada sistema.

#### Ejemplo

```sql
CREATE ROLE RolConsulta;

GRANT SELECT ON Donante TO RolConsulta;
GRANT SELECT ON Receptor TO RolConsulta;
GRANT SELECT ON Organo TO RolConsulta;

ALTER ROLE RolConsulta
ADD MEMBER UsuarioConsulta;
```

La utilización de roles simplifica considerablemente la administración de permisos, ya que basta con agregar o quitar usuarios del rol para modificar automáticamente sus privilegios, evitando configuraciones repetitivas y facilitando el mantenimiento del sistema.

### Aplicación en el Proyecto "Ley_Justina"

Para la base de datos desarrollada en este proyecto se implementó un esquema básico de seguridad utilizando usuarios, permisos y roles.

Se creó un usuario administrador con control total sobre la base de datos mediante el rol **db_owner**, mientras que **UsuarioMedico** recibió únicamente permisos de consulta sobre las tablas necesarias para su trabajo y autorización para ejecutar un procedimiento almacenado encargado de registrar trasplantes.

Asimismo, se creó un rol personalizado denominado **RolConsulta**, destinado a usuarios que únicamente requieren consultar información sobre donantes, receptores y órganos. Los usuarios asociados a este rol heredaron automáticamente dichos permisos, mientras que aquellos sin asignación de rol no pudieron acceder a la información protegida.

Esta implementación permitió comprobar el correcto funcionamiento de la administración de permisos tanto a nivel de usuarios individuales como mediante roles personalizados.

### Conclusión

El manejo de permisos constituye uno de los pilares fundamentales de la seguridad en cualquier sistema de bases de datos. Una adecuada asignación de privilegios permite proteger la información almacenada, controlar el acceso de los distintos usuarios y garantizar que cada uno disponga únicamente de los permisos necesarios para desarrollar sus funciones.

En el proyecto **Ley_Justina** se aplicaron estos conceptos mediante la creación de usuarios con distintos niveles de acceso, la utilización de procedimientos almacenados para ejecutar operaciones críticas de forma segura y la implementación de roles personalizados para simplificar la administración de permisos.

Este enfoque sigue el **principio del mínimo privilegio**, una de las prácticas más recomendadas en la administración de bases de datos, ya que contribuye a preservar la confidencialidad, integridad y disponibilidad de la información, además de facilitar la escalabilidad y el mantenimiento futuro del sistema.