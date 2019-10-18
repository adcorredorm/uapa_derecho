Repositorio creado con la finalidad de extraer información académica para la Facultad de Derecho, Ciencias Politicas y Sociales de la Universidad Nacional de Colombia.

Para ejecutar este script es necesario contar con:
  
 * Una terminal de Linux (por ejemplo Ubuntu o Linux Mint).
 * Conexión a Internet estable.
 * [Python][python] 3.6 o superior instalado.
 * [Pip][pip] y/o pip3 instalado.

Como ejecutar el script: 
 1. Contar con un usuario que tenga permisos de consulta en SIA. 
 2. El usuario y contraseña deben ser colocados en la raiz del proyecto en un archivo llamado *credenciales.txt* de la siguiente forma:

        usuario
        contraseña

 3. Rellenar el archivo info.xlsx con las cedulas, nombres y tipo de vinculación de las personas sobre que se quieren consultar.
 4. Ejecuar el archivo Main.sh que se encuentra en la raiz del proyecto.

Cuenta con los siguientes modulos:
  
**Colciencias**:
 
 Modulo encargado de extraer la informacion de cvlac y organizarla en las secciones:

 * articulos
 * capitulos
 * comites
 * eventos
 * idiomas
 * impresos
 * libros
 * prototipos
 * reconocimientos
 * redes
 * software
 * titulos
 * traducciones

Este modulo puede ser ejecutado de manera independiente, para mas detalles ingresar al modulo.


**SIA**
 
 Modulo encargado de extraer la información del Sistema de Academica de la Universidad (Octubre de 2019), la informacion extraida corresponde a:

 * asignaturas cursadas
 * avance % de carrera (solo aplica para las carreras pertenecientes a la Facultad de Derecho, Ciencias Politicas y Sociales)
 * datos personales
 * historias academicas
 * resumen de asignaturas
 * resumen de creditos
 * estudiantes que no existen en el sistema de información SIA
Este modulo puede ser ejecutado de manera independiente, para mas detalles ingresar al modulo.


**Controlador**

Modulo encargado de la coordinacion de los modulos anteriores.

[python]: <https://www.python.org/downloads/>
[pip]: <https://pip.pypa.io/en/stable/installing/>