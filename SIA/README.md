> Este codigo es solo una extension y uso, adaptado para la Facultad de Derecho, Ciencias Politicas y Sociales, del [script SIA][SIA] desarrollado por el equipo de la Unidad de Apoyo a los Procesos de Autoevaluación (UAPA) de la Facultad de Ingenieria

Para ejecutar este modulo es necesario tener la lista de documentos en un archivo llamado *dnis.txt* ubicado en la raiz del modulo, luego ejecutar el comando
    
    python Main.py 20  

En caso de que se ejecute este modulo de manera independiente deben estar configuradas las siguientes variables de ambiente:

    SIAUSER=usuario
    SIAPASS=contraseña

siendo estos los datos correspondientes al usuario con permisos de consulta en SIA. 

En caso de error puede ser necesario modificar el archivo */SIA/script_sia/SIARetrieve/SIAInfo.py* en la linea 23 cambiando websia1 por websia2 (esto debido al funcionamiento impredecible del SIA).

[SIA]: <https://github.com/uapa-team/script_sia>