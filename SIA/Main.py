import sys
from multiprocessing import Process
from Controller import Controller
from Converter import csv_to_xlsx
import filesSetup
from info import get_info

def start_threads(threads):

  filesSetup.create_files()

  threads = int(threads)
  dnis  = open("dnis.txt", "r+")
  
  deck = []
  [deck.append([]) for i in range(threads)]

  dnis_size = 0
  for line in dnis:
    line = line.split("\n")[0]
    deck[dnis_size%threads].append(line)
    dnis_size += 1
  
  Controller.total_size = dnis_size

  dnis.close()

  th = []
  for i in range(threads):
    t = Process(target=get_info, args=(deck[i],))
    th.append(t)
    t.start()

  [t.join() for t in th]

  Controller.make_summary()

  path = filesSetup.path

  csv_to_xlsx([
    path + 'Resumen General.csv',
    path + 'Resumen Asignaturas.csv',
    path + 'Avance Carrera.csv',
    path + 'Datos Personales.csv',
    path + 'Historias Academicas.csv',
    path + 'Asignaturas Cursadas.csv',
    path + 'Resumen creditos.csv'
  ])

start_threads(sys.argv[1])
