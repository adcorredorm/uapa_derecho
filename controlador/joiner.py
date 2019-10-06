import xlrd
import xlsxwriter
import csv
from os import listdir
from os.path import isfile, join

info = xlrd.open_workbook('../info.xlsx')
sheet = info.sheet_by_index(0)
people = {}
max_name = 0

for i in range(1, sheet.nrows):
	cc = str(sheet.cell_value(i, 0)).split('.')[0]
	if not cc in people:
		name = sheet.cell_value(i, 1)
		people[cc] = {
			'name': name,
			'mod': set()
		}
		max_name = max(max_name, len(name))
	people[cc]['mod'].add(sheet.cell_value(i, 2))

base = ['Documento', 'Nombre', 'Vinculación']
titles = {
	'articulos' : base + ['Tipo Publicación', 'Autores', 'Titulo', 'País de Publicación', 'Categoria', 'ISSN', 'ed', 'v.', 'fasc.', 'Páginas', 'Año'],
	'capitulos' : base + ['Autores', 'Titulo', 'Libro', 'País de Publicacion', 'ISBN', 'ed.', 'v.', 'Páginas', '-', 'Año'],
	'comites' : base + ['Tipo', 'Nombres', 'Comité', 'Entidad'],
	'eventos' : base + ['Nombre del evento', 'tipo', 'Ambito', 'Fecha inicio', 'Fecha Fin', 'Lugar', 'Entidad Anfitriona', 'Productos [...]'],
	'idiomas' : base + ['Idioma', 'Habla', 'Escribe', 'Lee', 'Entiende'],
	'impresos' : base + ['Título', 'Tipo de Producción', 'Medio de Circulación', 'Ambito', 'Año', 'link'],
	'libros' : base + ['Tipo de Producción', 'Autores', 'Título', 'País', 'Año', 'ed.', 'ISBN', 'v.', 'pags'],
	'prototipos' : base + ['Tipo', 'Autores', 'Nombre Oficial', 'Nombre Comercial', 'País', 'año', 'palabras', 'areas', 'sectores'],
	'reconocimientos' : base + ['Reconocimiento', 'Lugar', 'Mes / Año'],
	'redes' : base + ['Categoría', 'Nombre Red', 'Tipo Red', 'Fecha creación', 'Fecha de cierre', 'Lugar', 'Cantidad participantes'],
	'software' : base + ['Categoría', 'Autores', 'Nombre Oficial', 'Nombre Comercial', 'Registro', 'Pais', 'Año', 'link', 'Ambiente'],
	'titulos' : base + ['Nivel', 'Institución', 'Título', 'Fecha', 'Trabajo de grado'],
	'traducciones' : base + ['Categoría', 'Autores', 'Título', 'País', 'Año', '-', 'Idioma de Traducción', 'Autor Original', 'Medio de Publicación', 'fasc.', 'v.'],
}

path = '../Resultados/parcial/'
book = xlsxwriter.Workbook(path + 'Compilado_cvlac.xlsx')
bold_f = book.add_format({'bold': True})

files = [f for f in listdir(path) if isfile(join(path, f)) and f in titles]
files.sort()

for f in files:
	with open(path + f, 'r+', encoding='Latin-1') as file:
		data = list(csv.reader(file, delimiter=';'))
		sheet = book.add_worksheet(f)
		
		sheet.write_row(0, 0, titles[f])
		sheet.set_row(0, None, bold_f)

		for i in range(len(titles[f])):
			sheet.set_column(i, i, len(titles[f][i]) + 5)
		sheet.set_column(1, 1, max_name)
		
		counter = 1
		for i in range(len(data)):
			cc = data[i][0]
			if cc in people:
				for mod in people[cc]['mod']:
					row = [cc, people[cc]['name'], mod] + data[i][1:]
					sheet.write_row(counter, 0, row)
					counter += 1

		sheet.autofilter(0, 0, counter - 1, len(titles[f]) - 1)

book.close()