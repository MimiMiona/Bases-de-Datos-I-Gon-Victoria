**Universidad Nacional del Nordeste** 

   
**Facultad de Ciencias Exactas y Naturales y Agrimensura** 

 

**Carrera:** Licenciatura en Sistemas de Información 

**Título:** Sistema de Gestión de Donación y Trasplantes

**Cátedra:** Bases de datos 1  
**Año:** 2026   
**Docentes:** Dario O. VILLEGAS

**Alumno:**  
 

| Nombre                   |     DNI    |
| :-----------------------:|------------|
| Gon Victoria Raquel      |    46776550|

# CAPÍTULO I: INTRODUCCIÓN   

## Objetivos del Proyecto
El presente proyecto tiene como objetivo principal diseñar e implementar una base de datos destinada a la gestión del proceso de donación y trasplante de órganos, tomando como referencia la Ley Justina (Ley N.º 27.447). La finalidad del sistema es centralizar la información involucrada en cada etapa del proceso, garantizando su integridad, seguridad y trazabilidad, además de facilitar la administración y consulta de los datos. Algunos objetivos claves para el proyecto son:

1. **Registrar donantes y receptores:** El sistema permitirá almacenar de manera organizada la información necesaria de las personas involucradas en el proceso de donación y trasplante.
2. **Administrar la lista de espera:** Permite administrar los pacientes que esperan trasplante, manteniendo un control ordenado de las solicitudes.
3. **Gestionar órganos disponibles:** Registrar los órganos aptos para trasplante, indicando su tipo, grupo sanguíneo, estado y disponibilidad para su posterior asignación.
4. **Registrar los procedimientos de trasplante:** Se almacenará la información correspondiente a cada trasplante realizado, relacionando donantes, receptores, hospitales y profesionales intervinientes.
5. **Facilitar consultas y estadísticas:** permitir la obtención de información útil para el seguimiento de pacientes, el control de los procesos y la generación de estadísticas relacionadas con las donaciones y los trasplantes.
6. **Escalabilidad y crecimiento futuro:** Aunque el sistema comienza con la gestión de donación de órganos, podrá ampliarse en futuras versiones para administrar también la donación de tejidos, células y otros elementos contemplados por la Ley Justina.

## Alcance del Proyecto
El alcance de este proyecto se centra en cubrir las funciones para la administración del proceso de donación y trasplante de órganos. Permitiendo almacenar y relacionar la información correspondiente a donantes, receptores, hospitales, profesionales de la salud, órganos disponibles, listas de espera y procedimientos de trasplante, garantizando la integridad y consistencia de los datos. Dentro del alcance del proyecto se incluyen las siguientes funcionalidades:

1. **Registro y administración de donantes y receptores:** captura de la información basica de las personas que quieren donar o recibir organos.
2. **Gestión de hospitales y profesionales responsables de los procedimientos:** administración de los hospitales y profesionales de la salud involucrados en el proceso de donación y trasplante, permitiendo registrar su participación en cada procedimiento.
3. **Administración de órganos disponibles para trasplante:** registro de los órganos disponibles indicando su tipo, grupo sanguíneo y disponibilidad para su asignación.
4. **Registro y seguimiento de la lista de espera:** permitirá administrar el estado de los pacientes desde su incorporación a la lista hasta la realización del trasplante o su baja del registro.
5. **Generación de consultas y estadísticas relacionadas con donaciones y trasplantes:** Elaboración de informes sobre la cantidad de donantes registrados, órganos disponibles, trasplantes realizados y pacientes en lista de espera, facilitando el seguimiento y la toma de decisiones.

### Limitaciones del Proyecto
1. El sistema se limita a la **gestión administrativa de la información** vinculada al proceso de donación y trasplante, sin almacenar la historia clínica completa de los pacientes.
2. No contempla el diagnóstico médico, los estudios clínicos ni la evaluación médica necesaria para determinar la compatibilidad entre donantes y receptores.
3. Se considera una **fase inicial académica**, con posibilidad de escalar en futuras versiones hacia módulos más avanzados (historia clínica completa, estudios de compatibilidad, agregando la opcion de mas elementos vitales como córneas, piel, huesos y médula ósea).
4. El sistema está pensado como una herramienta que permita organizar y administrar de manera eficiente la información relacionada con la donación y el trasplante de órganos, proporcionando una base sólida para futuras ampliaciones e integraciones con otros sistemas de gestión sanitaria.

# CAPÍTULO II: MARCO CONCEPTUAL O REFERENCIAL
La donación y el trasplante de órganos constituyen procesos de gran importancia dentro del sistema de salud, ya que permiten mejorar la calidad de vida e incluso salvar la vida de pacientes que requieren un órgano para continuar con su tratamiento. Debido a la cantidad de información involucrada y a la participación de distintos actores, resulta fundamental contar con mecanismos que permitan registrar y administrar los datos de manera organizada, garantizando la integridad, disponibilidad y trazabilidad de la información durante todo el proceso.

El sistema administra el proceso de donación y trasplante de órganos conforme a la Ley Justina. Su finalidad es centralizar la información necesaria para registrar donantes, receptores, hospitales, médicos, personal administrativo y órganos disponibles, facilitando la gestión de la lista de espera y de los procedimientos de trasplante.

El personal administrativo pertenece a un hospital de referencia y es responsable de registrar y mantener actualizada la información de donantes, receptores, órganos disponibles, asignaciones y lista de espera. Cuando se detecta un órgano compatible con un receptor, el sistema genera una asignación. Si el procedimiento se concreta, se registra el trasplante correspondiente; en caso contrario, la asignación se cancela y el receptor continúa o vuelve a la lista de espera, según corresponda.

De esta manera, el sistema proporciona una administración organizada y consistente de toda la información involucrada en el proceso, facilitando las consultas, el seguimiento de los procedimientos y la generación de información estadística.

# CAPÍTULO III: METODOLOGÍA SEGUIDA 
El desarrollo del proyecto se llevó a cabo en distintas etapas, con el objetivo de diseñar una base de datos que permita administrar de forma organizada la información relacionada con el proceso de donación y trasplante de órganos.

1. Fase de Diseño Conceptual: En esta etapa se realizó un estudio de la Ley Justina y del proceso de donación y trasplante de órganos, identificando las entidades involucradas, los datos necesarios y las relaciones existentes entre donantes, receptores, órganos, hospitales y profesionales de la salud. Ademas se elaboró el modelo entidad-relación, definiendo las entidades principales, sus atributos y las relaciones necesarias para representar correctamente el funcionamiento del sistema.

2. Fase de Diseño Lógico y Creación de Esquema de Base de Datos:
En esta etapa transformamos el diseño conceptual en un modelo logico que nos permitio entender mucho mas las relaciones y como seria la estructura de nuestra base de datos. En esta etapa se crearon tablas, se definieron claves primarias y foraneas, y se pusieron restricciones como CHECKS, UNIQUES y CONSTRAINT para evitar inconsistencias.

3. Fase de Implementación de la Base de Datos: En esta etapa se desarrolló la base de datos utilizando SQL Server. Se implementaron todas las tablas definidas en el modelo lógico junto con sus respectivas restricciones y relaciones. Asimismo, se preparó un conjunto de datos de prueba para verificar el correcto funcionamiento de la estructura y permitir la realización de consultas sobre la información almacenada.

4. Fase de Pruebas y Validación: Se realizaron distintas pruebas para verificar la integridad de los datos y el correcto funcionamiento de las relaciones entre las tablas. Además, se validó el cumplimiento de las principales reglas de negocio, comprobando el registro de donantes y receptores, la administración de la lista de espera, la asignación de órganos disponibles y el registro de los trasplantes realizados.

**Herramientas (Instrumentos y Procedimientos)**
El trabajo se realizó utilizando las siguientes herramientas y procedimientos:

1. **GITHUB**: Se utilizaron para versionar los scripts SQL, cambios en la BD y documentación del sistema  
2. **SQL Server Management Studio (SSMS)**: se utilizo para crear tablas, monitoreo y pruebas del sistema, el desarrollo y escritura de las consultas SQL.  
3. **ERDPlus** Mediante el ERDplus elaboramos los diagramas tanto conceptual como logico a partir de las especificaciones de los requerimientos que fueron surgiendo al plantear el problema en cuestión. 

# CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS 
Lo primero que decidimos implementar fue el diagrama en el modelo relacional y el de entidad-relacion a partir de la investigaciones que hicimos sobre como funcionaba el sistema actual y las modificaciones que proponiamos.
Estos fueron los resultados de ambos diagramas:

![imagen1](https://github.com/MimiMiona/Bases-de-Datos-I-Gon-Victoria/blob/main/doc/Modelado_de_Datos_Relacional.png)

![imagen2](https://github.com/MimiMiona/Bases-de-Datos-I-Gon-Victoria/blob/main/doc/Diagrama_Base_de_Datos.png)

DICCIONARIO DE DATOS\
Este diccionario de datos documenta las tablas, campos y relaciones de la base de datos del proyecto. Su objetivo es facilitar la comprensión, el desarrollo y el mantenimiento del sistema, asegurando la correcta gestión e integridad de la información.
Accesso al documento [PDF](DER/DiccionarioDeDatos.pdf) del diccionario de datos.


# REGLAS DE NEGOCIO
Se definieron tambien las reglas de negocios para que se mantengan las consistencia de los datos
1. RN-01. Un donante puede donar uno o varios órganos. Cada órgano registrado en el sistema pertenece a un único donante.
2. RN-02. Cada órgano corresponde a un único tipo de órgano y solo puede encontrarse en uno de los siguientes estados: Disponible, Asignado, Trasplantado o Descartado.
3. RN-03. Todo receptor que requiera un trasplante debe estar registrado en la lista de espera. Un receptor solo puede tener una inscripción activa en dicha lista.
4. RN-04. La prioridad de cada receptor dentro de la lista de espera se determina de acuerdo con los criterios médicos definidos por el sistema.
5. RN-05. Solo los órganos cuyo estado sea Disponible podrán ser considerados para una asignación.
6. RN-06. Cuando exista un órgano compatible con un receptor registrado en la lista de espera, el sistema generará una asignación entre ambos, quedando el órgano en estado Asignado.
7. RN-07. Cada asignación vincula un único órgano con un único receptor y constituye el paso previo a la realización del trasplante.
8. RN-08. Cada trasplante involucra un único órgano, un único donante, un único receptor, un médico responsable y un hospital habilitado para realizar el procedimiento.
9. RN-09. Si el trasplante se realiza correctamente, el receptor será dado de baja de la lista de espera y el órgano cambiará su estado a Trasplantado.
10. RN-10. Si el trasplante no puede concretarse, la asignación será cancelada. El receptor permanecerá o volverá a la lista de espera y el órgano podrá volver al estado Disponible, siempre que continúe siendo apto para el trasplante; en caso contrario, será marcado como Descartado.
11. RN-11. Cada médico pertenece a un hospital habilitado para realizar procedimientos de donación y trasplante, desde el cual participa en los procedimientos registrados por el sistema.
12. RN-12. El personal administrativo pertenece a un hospital de referencia y es responsable de la gestión administrativa del proceso de donación y trasplante. Entre sus funciones se encuentran el registro y actualización de donantes, receptores, órganos disponibles, asignaciones y lista de espera, sin intervenir en los procedimientos médicos.
