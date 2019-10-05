all: clean
	sh Main.sh
	
clean:
	rm -f -r Resultados
	rm -f -r colciencias/resultados
	rm -f -r SIA/Resultados
	rm -f colciencias/enlaces/dnis.txt
	rm -f colciencias/enlaces/output.txt
	clear