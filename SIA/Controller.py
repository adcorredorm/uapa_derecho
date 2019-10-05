import filesSetup
from datetime import datetime
from multiprocessing import Value, Manager

#Esta clase lleva el control y hace el seguimiento de la ejecucion completa del script
class Controller:

  total_size = 0
  counter = Value('i', 0)
  valid_counter = Value('i', 0)
  manager = Manager()
  periods = manager.dict()
  subjects = manager.dict() 

  def increase_counter(valid = True):
    Controller.counter.value += 1
    if valid:
      Controller.valid_counter.value += 1
    
    print('SIA:', Controller.counter.value, '/', Controller.total_size)
  
  def add_student(period, carrer_code, carrer_name, progress, total_progress):
    if period not in Controller.periods:
      Controller.periods[period] = Controller.manager.dict()
    
    if carrer_code not in Controller.periods[period]:
      Controller.periods[period][carrer_code] = Controller.manager.dict({
        "name": carrer_name,
        "students": 0,
        "progress": 0,
        "total_progress": 0
      })
    

    Controller.periods[period][carrer_code]["students"] += 1
    Controller.periods[period][carrer_code]["progress"] += progress
    Controller.periods[period][carrer_code]["total_progress"] += total_progress
      

  def add_subject(code, name, period, approved = True):
    if code not in Controller.subjects:
      Controller.subjects[code] = Controller.manager.dict({
        "name": name,
        "students": 0,
        "periods": Controller.manager.list(),
        "reproved": 0
      })

    Controller.subjects[code]["students"] += 1
    if period not in Controller.subjects[code]._getvalue()["periods"]:
      Controller.subjects[code]["periods"].append(period)
    if not approved:
      Controller.subjects[code]["reproved"] += 1

  
  def make_summary():
    
    path = filesSetup.path

    file = open(path + "Resumen General.csv", "w+")

    file.write("Ejecucion Realizada:\t{}\n\n".format(datetime.now().strftime("%d/%m/%Y")))
    file.write("Estudiantes Válidos:\t{}\n\n".format(Controller.valid_counter.value))

    file.write(
      "Periodo\tPrograma\tCódigo Programa\tEstudiantes Activos\tPromedio de Avance Semestre\tPromedio Avance Total\n"
      )
    
    for period in Controller.periods:
      file.write(period + "\n")
      for carrer in Controller.periods[period]._getvalue():
        aux = Controller.periods[period]._getvalue()[carrer]._getvalue()
        total_students = aux["students"]
        text = "\t{}\t{}\t{:d}\t{:0.2f}%\t{:0.2f}%\n".format(
            aux["name"], carrer, total_students,
            aux["progress"]/total_students,
            aux["total_progress"]/total_students
          )
        file.write(text)

    file.close()

    file = open(path + "Resumen Asignaturas.csv", "w+")

    file.write("Codigo Asignatura\tNombre\tEstudiantes Promedio por semestre\tTasa de perdida\n")

    for subject in Controller.subjects:
      aux = Controller.subjects[subject]
      total_students = aux["students"]
      periods = len(aux["periods"])
      text = "{}\t{}\t{:0.2f}\t{:0.2f}%\n".format(
          subject, aux["name"],
          total_students/periods,
          (aux["reproved"]/total_students) * 100
        )

      file.write(text)

    file.close()
