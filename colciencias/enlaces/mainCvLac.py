import urllib.request
import re
clear = open("output.txt", "w")
clear.write("")
clear.close()
inputFile = open("dnis.txt", "r")
outputFile = open("output.txt", "a+")
lines = inputFile.readlines()
i = 0
for dni in lines:
    i = i+1
    url = 'https://sba.colciencias.gov.co/tomcat/Buscador_HojasDeVida/busqueda?q=' + \
        dni.replace("\n", "")
    try:
        htmlSource = str(urllib.request.urlopen(url).read())
        matchObj = re.search(
            "https://scienti.colciencias.gov.co/cvlac/visualizador/generarCurriculoCv.do%3Fcod_rh%3D([0-9]*)", htmlSource)
        outputFile.write(
            dni.replace("\n", "") + "," + str(matchObj.group()).replace("%3F", "?").replace("%3D", "=") + "\n")
        print(i, "/", len(lines))
    except Exception:
        outputFile.write(
            dni.replace("\n", "") + "," + "\n")
        continue
inputFile.close()
outputFile.close()
