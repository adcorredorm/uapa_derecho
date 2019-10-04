import toStringHelpers
import filesSetup
from Controller import Controller
from script_sia.EstudianteSia import EstudianteSia

path = filesSetup.path
creditos = {
    "2538": 126,  # Pre. Ciencias Politicas
    "2539": 181,  # Pre. Derecho
    "2411": 32,  # Esp. Analisis de Politicas Públicas
    "2412": 32,  # Esp. Derecho Administrativo
    "2415": 32,  # Esp. Derecho Constitucional
    "2414": 32,  # Esp. Derecho de Familia
    "2410": 32,  # Esp. Derecho del Trabajo
    "2413": 32,  # Esp. Derecho Economico Privado
    "2791": 32,  # Esp. Derechos Humanos
    "2670": 32,  # Esp. Instituciones juridicas de la seguridad social
    "2671": 32,  # Esp. Instituciones juridico penales
    "2672": 32,  # Esp. Instituciones juridico procesales
    "2937": 32,  # Esp. Justicia, Victimas y construccion de paz
    "2673": 32,  # Esp. Mercados y suelos en america latina
    "2566": 112,  # Mae. Biociencias y Derecho
    "2674": 60,  # Mae. Derecho
    "2826": 60,  # Mae. Politicas Publicas
    "2833": 60,  # Mae. Estudios Politicos latinoamericanos
    "2569": 125,  # Doc. Estudios politicos y relaciones internacionales
    "2823": 125  # Doc. Derecho
}


def get_info(dnis):

    dp = open(path + "Datos Personales.csv", "a")
    ha = open(path + "Historias Academicas.csv", "a")
    mat = open(path + "Asignaturas Cursadas.csv", "a")
    res = open(path + "Resumen creditos.csv", "a")
    av = open(path + "Avance Carrera.csv", "a")
    bl = open(path + "Error.txt", "a")

    for dni in dnis:

        try:
            student = EstudianteSia(dni)
            student_name = student.dp.parser.get_name()

            dp.write(str(student.dp))
            carreras = {}

            aux = ""
            for historia in student.dp.ha:
                aux += toStringHelpers.dp_historia(dni,
                                                   student_name, student.dp.ha, historia)
                carreras[historia] = student.dp.ha[historia]['programa'].split(' | ')[
                    1]
            ha.write(aux)

            for hist in student.ha:
                aux = ""
                program = hist.programa
                creditos_aprovados_totales = 0
                avance = 0

                for periodo in hist.periodos:
                    creditos_aprovados = 0
                    for materia in periodo.materias:
                        aux += toStringHelpers.ha_materia(
                            dni, student_name, program, carreras[program], periodo.periodo, materia)
                        if toStringHelpers.is_approved(materia.nota) and materia.tipologia in ['B', 'O', 'T', 'C', 'L']:
                            creditos_aprovados += int(materia.creditos)
                        Controller.add_subject(
                            materia.codigo, materia.nombre, periodo.periodo, toStringHelpers.is_approved(materia.nota))

                    creditos_aprovados_totales += creditos_aprovados

                    if program in creditos:
                        nuevo_avance = (
                            creditos_aprovados_totales/creditos[program]) * 100
                        av.write(
                            dni + '\t' + student_name + '\t' + program + '\t' + carreras[program] + '\t' + periodo.periodo + '\t' +
                            '{:0.2f}%'.format(nuevo_avance - avance) + '\t' +
                            '{:0.2f}%'.format(nuevo_avance) + '\n'
                        )

                        Controller.add_student(
                            periodo.periodo, program, carreras[program], nuevo_avance - avance, nuevo_avance)
                        avance = nuevo_avance

                mat.write(aux)
                res.write(toStringHelpers.resumen(
                    hist.resumen, student_name, carreras[program]))

            Controller.increase_counter()

        except Exception as e:
            bl.write(dni)
            bl.write('\t' + str(e) + '\n')
            Controller.increase_counter(False)

        dp.flush()
        ha.flush()
        mat.flush()
        res.flush()
        av.flush()
        bl.flush()

    dp.close()
    ha.close()
    mat.close()
    res.close()
    av.close()
    bl.close()
