# TEMA: Manejo de tipos de datos JSON en SQL Server

### Introducción

El formato **JSON (JavaScript Object Notation)** es una estructura ligera utilizada para almacenar, intercambiar y representar información de manera flexible. En la actualidad, JSON se ha convertido en uno de los formatos más utilizados en el desarrollo de aplicaciones web, móviles y sistemas de integración, debido a su facilidad de lectura y su compatibilidad con distintos lenguajes de programación.

En **SQL Server**, JSON no se maneja como un tipo de dato nativo independiente, sino que se almacena generalmente en columnas de tipo **NVARCHAR(MAX)** o **VARCHAR(MAX)**. Aun así, SQL Server incorpora funciones específicas que permiten consultar, modificar y transformar datos JSON directamente desde la base de datos, sin necesidad de procesarlos previamente fuera del motor.

En el proyecto **Ley_Justina**, el uso de JSON resulta útil para representar información compleja y relacionada entre entidades como donantes, receptores, órganos, hospitales, doctores y trasplantes, permitiendo agrupar datos en una sola estructura semiestructurada.

### ¿Qué es JSON?

JSON es un formato de texto utilizado para representar datos estructurados mediante pares **clave/valor**.
Cada dato se organiza de forma simple y clara, lo que facilita su intercambio entre sistemas.

#### Ejemplo de JSON

```json
{
  "Nombre": "Juan",
  "Edad": 30,
  "Ciudad": "Mar del Plata",
  "Correo": "juan@example.com"
}
```

En este ejemplo, cada elemento tiene una **clave** y un **valor**:

* **Nombre** → Juan
* **Edad** → 30
* **Ciudad** → Mar del Plata
* **Correo** → [juan@example.com](mailto:juan@example.com)

### Características de JSON

JSON presenta varias características importantes:

* Es un formato ligero y fácil de interpretar.
* Permite representar información compleja de forma ordenada.
* Puede almacenar datos anidados.
* Es ampliamente utilizado en APIs y aplicaciones web.
* Se adapta bien a estructuras semiestructuradas.

En bases de datos, JSON permite guardar información flexible dentro de una sola columna, lo que resulta útil cuando los datos no tienen siempre la misma estructura.

### Almacenamiento de datos JSON en SQL Server

En SQL Server, los datos JSON se almacenan dentro de columnas de texto, normalmente en:

* **NVARCHAR(MAX)**
* **VARCHAR(MAX)**

Para asegurar que el contenido sea válido, se puede utilizar la función **ISJSON()**, que valida si una cadena tiene formato JSON correcto.

#### Ejemplo de almacenamiento

```sql
CREATE TABLE Expediente_JSON (
    id_expediente INT IDENTITY(1,1) PRIMARY KEY,
    datos_json NVARCHAR(MAX),
    CONSTRAINT CK_Expediente_JSON CHECK (ISJSON(datos_json) > 0)
);
```

Este enfoque permite guardar estructuras completas en una sola columna, manteniendo la flexibilidad del formato JSON.

### Procesamiento de datos JSON en SQL Server

SQL Server incluye funciones nativas para trabajar con JSON directamente. Estas funciones permiten leer, extraer, modificar y descomponer datos sin convertirlos previamente en tablas.

#### Funciones principales

* **OPENJSON**: descompone un JSON en filas y columnas.
* **JSON_VALUE**: extrae un valor específico de un campo JSON.
* **JSON_QUERY**: devuelve un objeto o arreglo JSON completo.
* **JSON_MODIFY**: modifica un valor dentro de un JSON.

#### Ejemplo de uso de JSON en el proyecto Ley_Justina

Para representar información relacionada con trasplantes, se puede crear una tabla que almacene un expediente completo en formato JSON.
Esto permite reunir en un solo registro información de varias entidades relacionadas.

#### Ejemplo de estructura JSON

```json
{
  "id_transplante": 1,
  "estado": "Finalizado",
  "observacion": "Paciente estable",
  "donante": {
    "nombre": "Carlos",
    "apellido": "Pérez"
  },
  "receptor": {
    "nombre": "María",
    "apellido": "López"
  },
  "organo": {
    "tipo_organo": "Rin"
  },
  "hospital": {
    "nombre_hospital": "Hospital Central"
  }
}
```

Esta estructura facilita la consulta de datos complejos y permite organizar la información de manera más compacta.

### Consulta de datos JSON

Una de las ventajas más importantes de JSON en SQL Server es la posibilidad de consultar valores específicos dentro del contenido almacenado.

#### Ejemplo con JSON_VALUE

```sql
SELECT
    JSON_VALUE(datos_json, '$.estado') AS Estado,
    JSON_VALUE(datos_json, '$.donante.nombre') AS NombreDonante,
    JSON_VALUE(datos_json, '$.receptor.nombre') AS NombreReceptor
FROM Expediente_JSON;
```

En este caso, se extraen valores puntuales de un JSON almacenado en la base de datos.

#### Ejemplo con JSON_QUERY

```sql
SELECT
    JSON_QUERY(datos_json, '$.donante') AS DonanteCompleto,
    JSON_QUERY(datos_json, '$.receptor') AS ReceptorCompleto
FROM Expediente_JSON;
```

**JSON_QUERY** se utiliza cuando se desea recuperar un objeto JSON completo, no solo un valor simple.

### Conversión de JSON a filas y columnas

La función **OPENJSON** permite transformar el contenido JSON en una estructura tabular.
Esto es útil cuando se necesita recorrer cada clave y valor o mapear propiedades a columnas específicas.

#### Ejemplo

```sql
SELECT
    e.id_expediente,
    j.[key] AS Clave,
    j.[value] AS Valor
FROM Expediente_JSON e
CROSS APPLY OPENJSON(e.datos_json) AS j;
```

También es posible mapear campos anidados directamente a columnas:

```sql
SELECT
    e.id_expediente,
    x.nombre_donante,
    x.tipo_organo,
    x.nombre_hospital
FROM Expediente_JSON e
CROSS APPLY OPENJSON(e.datos_json)
WITH (
    nombre_donante NVARCHAR(50) '$.donante.nombre',
    tipo_organo NVARCHAR(50) '$.organo.tipo_organo',
    nombre_hospital NVARCHAR(100) '$.hospital.nombre_hospital'
) AS x;
```

### Modificación de datos JSON

SQL Server permite modificar valores dentro de un JSON utilizando **JSON_MODIFY**.

#### Ejemplo

```sql
UPDATE Expediente_JSON
SET datos_json = JSON_MODIFY(datos_json, '$.observacion', 'Paciente estable luego de la cirugía')
WHERE id_transplante = 4;
```

También se pueden agregar nuevos campos:

```sql
UPDATE Expediente_JSON
SET datos_json = JSON_MODIFY(datos_json, '$.seguimiento', 'Control postoperatorio en 48 horas')
WHERE id_transplante = 4;
```

Estas operaciones resultan útiles cuando se necesita actualizar solo una parte de la información sin reemplazar todo el documento JSON.

### Filtrado y búsqueda de registros JSON

Los datos JSON también pueden usarse en cláusulas **WHERE** para filtrar información según un valor específico.

#### Ejemplo

```sql
SELECT
    id_expediente,
    JSON_VALUE(datos_json, '$.estado') AS Estado
FROM Expediente_JSON
WHERE JSON_VALUE(datos_json, '$.organo.tipo_organo') = 'Rin';
```

Este tipo de consulta permite buscar registros según campos internos del JSON.

### Optimización de consultas con JSON

Aunque JSON ofrece mucha flexibilidad, consultar repetidamente funciones como **JSON_VALUE** sobre grandes volúmenes de datos puede afectar el rendimiento.

Para optimizar estas consultas, se recomienda:

* Crear **columnas calculadas** a partir de valores JSON.
* Indexar esas columnas calculadas.
* Evitar extraer el mismo valor JSON muchas veces en una consulta.

#### Ejemplo de columna calculada

```sql
ALTER TABLE Expediente_JSON
ADD
    estado_json AS LEFT(JSON_VALUE(datos_json, '$.estado'), 20) PERSISTED,
    tipo_organo_json AS LEFT(JSON_VALUE(datos_json, '$.organo.tipo_organo'), 50) PERSISTED,
    nombre_donante_json AS LEFT(JSON_VALUE(datos_json, '$.donante.nombre'), 50) PERSISTED;
```

#### Ejemplo de índice

```sql
CREATE INDEX IX_Expediente_JSON_Tipo_Estado
ON Expediente_JSON (tipo_organo_json, estado_json)
INCLUDE (nombre_donante_json);
```

Con esta técnica, SQL Server puede resolver consultas de forma más eficiente.

### Aplicación en el proyecto Ley_Justina

En el proyecto **Ley_Justina**, el uso de JSON permite representar expedientes de trasplante de forma organizada y flexible.
Cada expediente puede incluir información de varias tablas relacionadas en un solo documento, lo que simplifica la consulta y el análisis de datos.

Esta forma de almacenamiento es especialmente útil cuando:

* Se desea agrupar datos relacionados.
* Se necesitan estructuras anidadas.
* Se quiere compatibilidad con APIs o sistemas externos.
* Se busca flexibilidad sin abandonar una base relacional.

Además, el uso de funciones nativas de SQL Server facilita tareas como consultar, modificar, filtrar y optimizar datos JSON.

### Conclusión

El manejo de datos JSON en SQL Server es una solución práctica para almacenar y procesar información semiestructurada, en un entorno relacional. Aunque JSON no es un tipo de dato nativo independiente, SQL Server ofrece herramientas muy útiles para trabajar con este formato de manera eficiente.

Las funciones **OPENJSON**, **JSON_VALUE**, **JSON_QUERY** y **JSON_MODIFY** permiten consultar y modificar datos directamente desde la base de datos, lo que mejora la flexibilidad en el tratamiento de la información.

En el proyecto **Ley_Justina**, JSON resulta especialmente útil para representar expedientes completos de trasplante, ya que permite integrar datos de diferentes entidades en una sola estructura.
De esta manera, JSON se convierte en una herramienta estratégica para sistemas que requieren organización, flexibilidad y compatibilidad con aplicaciones modernas.
