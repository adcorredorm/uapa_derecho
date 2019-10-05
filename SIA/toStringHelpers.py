def dp_historia(dni, student_name, historias, historia):
	aux = ""
	aux += dni + "\t" + student_name + "\t" + historia + "\t"
	for dato in historias[historia]:
		aux += historias[historia][dato] + "\t"
	aux += "\n" 
	return aux

def ha_materia(dni, student_name, program, program_name, periodo, materia):
	aux = "" + dni + "\t" + student_name + "\t" + program + "\t" + program_name + "\t" + periodo + "\t"
	aux += materia.codigo + "\t" + materia.nombre.strip() + "\t" + materia.grupo + "\t" + materia.tipologia + "\t" + materia.creditos + "\t" + materia.nota
	if is_approved(materia.nota):
		aux += "\tAprueba\n"
	else:
		aux += "\tNo Aprueba\n"
	return aux


def is_approved(nota):
	try:
		return float(nota) >= 3.0
	except ValueError:
		return nota in ("AP", "AS")

def resumen(res, name, carrer):
	string = res.dni + "\t" + name + "\t" + res.programa + "\t" + carrer + "\t"
	string += res.PA.split(']')[0] + "\t" + res.PAPA + "\t" + res.porc + "\t"
	for i in res.infocreditos:
		for d in res.infocreditos[i]:
				string += d + "\t"

	return string + "\n"