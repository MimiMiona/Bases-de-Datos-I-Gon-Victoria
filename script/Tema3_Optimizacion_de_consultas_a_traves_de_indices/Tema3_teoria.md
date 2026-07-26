### Tema 3: Optimización de consultas a través de índices

### Introducción

Los índices son estructuras que se utilizan en una base de datos para mejorar el rendimiento de las consultas y acelerar el acceso a los datos. Su función principal es evitar recorrer toda una tabla cuando se realiza una búsqueda, permitiendo ubicar la información de manera más rápida y eficiente.

En SQL Server, los índices pueden ser de distintos tipos. Los más utilizados son los **índices agrupados** y los **índices no agrupados**. Los índices agrupados ordenan físicamente los datos de la tabla según la clave definida, mientras que los índices no agrupados crean una estructura independiente que facilita la búsqueda sobre una o varias columnas específicas.

El uso correcto de índices contribuye a optimizar consultas frecuentes, reducir tiempos de respuesta y mejorar el desempeño general del sistema.

### Actividad realizada

Para aplicar estos conceptos se trabajó sobre la base de datos del proyecto **Ley Justina**, en la cual se analizaron las tablas principales del sistema, como **Donante, TipoOrgano, Organo, Receptor, Hospital, Doctor** y **Administrativo**.

El objetivo fue observar cómo cambia el comportamiento de las consultas al aplicar distintos tipos de índices sobre columnas utilizadas habitualmente en búsquedas, filtrados y relaciones entre tablas.

### 1. Análisis de consultas frecuentes

Durante la práctica se identificaron varias columnas de uso habitual dentro del sistema, especialmente aquellas relacionadas con claves primarias, claves foráneas y campos de búsqueda como:

* `id_donante`
* `id_tipoOrgano`
* `id_organo`
* `id_receptor`
* `id_hospital`
* `dni`
* `telefono`
* `estado`
* `nombre_hospital`

Estas columnas resultan importantes porque se utilizan con frecuencia para localizar registros, unir tablas y aplicar filtros dentro de las consultas.

### 2. Desarrollo de índices agrupados

Se analizó el comportamiento de los índices agrupados sobre columnas clave de acceso a los datos. En este caso, los índices agrupados permiten organizar la información de forma ordenada y facilitar la recuperación de registros cuando se realizan búsquedas por identificador.

Este tipo de índice resulta especialmente útil en tablas donde se consulta de manera constante por claves principales, ya que mejora la velocidad de acceso y reduce el trabajo del motor de base de datos al ejecutar la consulta.

### 3. Desarrollo de índices no agrupados

También se trabajó con índices no agrupados sobre columnas utilizadas para filtrar resultados o realizar búsquedas específicas.

Por ejemplo, en tablas como **Receptor**, **Doctor** y **Hospital**, los campos `dni`, `telefono` y `nombre_hospital` son buenos candidatos para este tipo de índice, ya que permiten localizar datos con mayor rapidez sin modificar el orden físico de la tabla.

Además, los índices no agrupados pueden incluir columnas adicionales para evitar accesos innecesarios a la tabla, lo que contribuye a una mejor optimización de las consultas.

### 4. Relación entre índices y estructura de la base de datos

En la base de datos del proyecto **Ley Justina** se observa una estructura relacional bien definida, donde varias tablas están conectadas mediante claves primarias y foráneas.

Por ejemplo:

* **Organo** se relaciona con **Donante** y **TipoOrgano**.
* **Doctor** y **Administrativo** se relacionan con **Hospital**.
* **Receptor** se vincula con **Organo**.

Estas relaciones hacen que los índices sean especialmente útiles, ya que mejoran el rendimiento de las consultas que incluyen `JOIN`, filtros por identificador y búsquedas por campos únicos.

### Comparación entre índice agrupado e índice no agrupado

Durante la práctica se observó lo siguiente:

| Índice agrupado                                         | Índice no agrupado                                           |
| ------------------------------------------------------- | ------------------------------------------------------------ |
| Ordena físicamente los datos de la tabla.               | Crea una estructura separada para la búsqueda.               |
| Solo puede existir uno por tabla.                       | Se pueden crear varios en una misma tabla.                   |
| Es útil para búsquedas por rangos y claves principales. | Es útil para búsquedas por columnas frecuentes.              |
| Mejora el acceso directo a los registros.               | Puede incluir columnas adicionales para optimizar consultas. |

* Los índices agrupados son más apropiados cuando se necesita ordenar y recuperar datos de forma secuencial, mientras que los índices no agrupados son más flexibles para consultas específicas sobre campos secundarios.

### Ventajas observadas

Durante el desarrollo de esta práctica se comprobó que el uso de índices ofrece diversas ventajas:

* Mejora el tiempo de respuesta de las consultas.
* Reduce la cantidad de datos que debe recorrer la base de datos.
* Optimiza búsquedas frecuentes.
* Facilita el trabajo con relaciones entre tablas.
* Mejora el rendimiento general del sistema.
* Permite una recuperación más rápida de registros específicos.
* Ayuda a optimizar consultas con filtros y uniones entre tablas.

### Objetos analizados

#### Índices agrupados

* Índice sobre claves principales de las tablas.
* Optimización de búsquedas por identificador.

#### Índices no agrupados

* Índice sobre `dni`.
* Índice sobre `telefono`.
* Índice sobre `estado`.
* Índice sobre `nombre_hospital`.
* Índice sobre columnas foráneas y campos de búsqueda frecuente.

### Conclusiones

La práctica de optimización de consultas mediante índices permitió comprender la importancia de elegir correctamente las columnas sobre las que se crean estas estructuras.

Los índices agrupados mejoran el acceso ordenado a los registros, mientras que los índices no agrupados resultan muy útiles para acelerar búsquedas puntuales y consultas filtradas. En conjunto, ambos tipos de índices contribuyen a que la base de datos trabaje de forma más eficiente y responda mejor ante grandes volúmenes de información.

En la base de datos del proyecto **Ley Justina**, el uso de índices sobre campos como identificadores (DNI, teléfono, etc) y relaciones entre tablas, favorece la optimización de consultas y mejora la administración general del sistema.
