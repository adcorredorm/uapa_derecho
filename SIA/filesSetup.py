import os

path = "Resultados/csv_files/"

def create_files():

  if not os.path.exists(path):
    os.mkdir(path)

  dp = open(path + "Datos Personales.csv", "w+")
  dp.write(
    "Documento\tNombre\tSexo\tEdad\tEstado Civil\tPais\t" +
    "Direccion Procedecia\tTipo de Domicilio\tMunicipio\tDepartamento\tPais\tTeléfono 1\tTeléfono2\t" +
    "Direccion Residencia\tMunicipio\tDepartamento\tPais\tTelefono1\tTelefono2\t" +
    "Fecha de Nacimiento\tMunicipio\tDepartamento\tPais\tNacionalidad\t" +
    "Número de Libreta Militar\tClase\tDistrito\tSituacion\t" +
    "Usuario SIA\tCorreo Institucional\tCorreo Alterno\t" +
    "Grupo Sanguineo\tRH\tEPS\n"
  )
  dp.close()

  ha = open(path + "Historias Academicas.csv", "w+")
  ha.write(
    "Documento\tNombre\tCodigo Programa\t" + 
    "Estado del expediente\tPrograma\tNivel\tCodigo del estudiante\t" +
    "Periodo de Ingreso\tTipo de ingreso\n"
  )
  ha.close()

  mat = open(path + "Asignaturas Cursadas.csv", "w+")
  mat.write(
    "Documento\tNombre\tCodigo Programa\tPrograma\t" +
    "Periodo\tCódigo\tAsignatura\tGrupo\tTipologia\tCréditos\tCalificación\tAprobada\n" 
  )
  mat.close()

  res = open(path + "Resumen creditos.csv", "w+")
  res.write(
    "Documento\tNombre\tCodigo Programa\tPrograma\tPromedio Académico\tP.A.P.A.\tPorcentaje de Avance\t" +
    "Exigidos FunOb\tExigidos FunOp\tExigidos DisOb\tExigidos DisOp\tExigidos TG\tExigidos L\tExigidos Total\tExigidos Niv\tExigidos Total Estudiante\t" +
    "Aprobados FunOb\tAprobados FunOp\tAprobados DisOb\tAprobados DisOp\tAprobados TG\tAprobados L\tAprobados Total\tAprobados Niv\tAprobados Total Estudiante\t" +
    "Pendientes FunOb\tPendientes FunOp\tPendientes DisOb\tPendientes DisOp\tPendientes TG\tPendientes L\tPendientes Total\tPendientes Niv\tPendientes Total Estudiante\t" +
    "Cursados FunOb\tCursados FunOp\tCursados DisOb\tCursados DisOp\tCursados TG\tCursados L\tCursados Total\tCursados Niv\tCursados Total Estudiante\t" +
    "Inscritos FunOb\tInscritos FunOp\tInscritos DisOb\tInscritos DisOp\tInscritos TG\tInscritos L\tInscritos Total\tInscritos Niv\tInscritos Total Estudiante\t" +
    "Créditos Adicionales\tCupo de Créditos\tCréditos Disponibles\tCréditos Doble Titulación\tCréditos Excedentes\tCréditos Cancelados\n"
  )
  res.close()

  av = open(path + "Avance Carrera.csv", "w+")
  av.write(
    "Documento\tNombre\tCodigo Programa\tPrograma\t" +
    "Periodo\tAvance Semestre\tAvance Total\n"
  )
  av.close()

  bl = open(path + "Error.txt", "w+")
  bl.close()
