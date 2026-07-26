# Tema 2: Procedimientos y Funciones Almacenadas

### Introducción

Los procedimientos y funciones almacenadas son objetos de una base de datos que permiten encapsular lógica SQL para reutilizarla de forma segura y eficiente.

Los **procedimientos almacenados** se crean mediante la sentencia `CREATE PROCEDURE` y se ejecutan utilizando `EXEC`. Se emplean principalmente para realizar operaciones sobre los datos, como inserciones, modificaciones y eliminaciones, además de permitir la recepción de parámetros de entrada y la ejecución de múltiples instrucciones SQL.

Por otro lado, las **funciones almacenadas** se crean con `CREATE FUNCTION` y se utilizan dentro de consultas `SELECT` o expresiones SQL. Su finalidad es devolver un valor o una tabla, permitiendo reutilizar cálculos y consultas frecuentes sin modificar la información almacenada.

El uso de estos objetos mejora la organización del código, facilita su mantenimiento, aumenta la seguridad de la base de datos y favorece la reutilización de procesos.


### Actividad Realizada

Para aplicar estos conceptos se desarrollaron procedimientos y funciones almacenadas sobre la base de datos del proyecto **Ley Justina**, destinado a la gestión de donantes, órganos y hospitales.

El objetivo fue implementar operaciones CRUD mediante procedimientos almacenados y desarrollar funciones que permitieran obtener información relevante de la base de datos, reutilizando código y mejorando la administración del sistema.

### 1. Desarrollo de Procedimientos Almacenados

Se implementaron procedimientos para realizar distintas operaciones sobre las tablas del sistema.

#### spInsertarDonante

Permite registrar un nuevo donante ingresando sus datos personales, como nombre, apellido, edad, género, peso, patología, tipo de sangre, teléfono y contraseña.

#### spActualizarEstadoOrgano

Actualiza el estado de un órgano, permitiendo cambiarlo entre los distintos estados manejados por el sistema, por ejemplo **Disponible** o **Asignado**.

#### spEliminarHospital

Elimina un hospital de la base de datos a partir de su identificador.

Posteriormente, cada procedimiento fue ejecutado mediante la instrucción `EXEC` para comprobar su correcto funcionamiento.


### 2. Desarrollo de Funciones Almacenadas

También se desarrollaron funciones con el objetivo de reutilizar consultas frecuentes y obtener información específica del sistema.

#### fnCantidadOrganosDisponibles

Devuelve la cantidad total de órganos cuyo estado es **Disponible**.

#### fnOrganosPorTipo

Retorna una tabla con los órganos pertenecientes a un determinado tipo, incluyendo información del donante asociado.

#### fnNombreCompletoDonante

Obtiene el nombre completo de un donante a partir de su identificador.

Estas funciones fueron invocadas mediante consultas `SELECT`, aprovechando la posibilidad de integrarlas dentro de otras consultas SQL.


### Comparación entre Procedimientos y Funciones

Durante el desarrollo se observó lo siguiente: 

| Procedimientos | Funciones |
|---------------|-----------|
| Se ejecutan mediante `EXEC`. | Se utilizan dentro de un `SELECT`. |
| Permiten realizar operaciones CRUD. | Devuelven un valor o una tabla. |
| Pueden contener múltiples instrucciones SQL. | No modifican directamente los datos. |
| Son adecuados para implementar lógica de negocio. | Son útiles para reutilizar consultas y cálculos. |

- Los procedimientos almacenados resultan más apropiados para realizar operaciones de inserción, actualización y eliminación de registros, mientras que las funciones se utilizan para obtener información o realizar cálculos que pueden incorporarse directamente en consultas.


### Ventajas observadas

Durante la implementación del proyecto se comprobó que el uso de procedimientos y funciones almacenadas ofrece diversas ventajas:

- Centralización de la lógica de negocio.
- Reutilización del código SQL.
- Mayor facilidad de mantenimiento.
- Mejor organización de la base de datos.
- Mayor seguridad mediante el uso de parámetros.
- Posibilidad de reutilizar funciones dentro de consultas SQL.
- Disminución de errores por duplicación de código.


### Objetos desarrollados

#### Procedimientos

- spInsertarDonante
- spActualizarEstadoOrgano
- spEliminarHospital

#### Funciones

- fnCantidadOrganosDisponibles
- fnOrganosPorTipo
- fnNombreCompletoDonante


### Conclusiones

La implementación de procedimientos y funciones almacenadas permitió aplicar los conceptos teóricos vistos en la materia sobre una base de datos real.

Los procedimientos facilitaron la ejecución de operaciones CRUD de forma organizada y segura, mientras que las funciones permitieron reutilizar consultas y obtener información específica dentro de sentencias `SELECT`.

En conjunto, ambos objetos contribuyen a desarrollar aplicaciones más mantenibles, seguras y eficientes, reduciendo la repetición de código y mejorando la administración de la base de datos del proyecto **Ley Justina**.