### Recolectando la informacion necesaria para los scripts ##
cd controlador
pip install -r requirements.txt > /dev/null
python separator.py
cp dnis.txt ../SIA/
cp dnis.txt ../colciencias/enlaces/
cd ..

### Ejecucion del script de cvlac ###
cd colciencias
mkdir -p resultados
./ext.sh &
pid_cv=$!
cd ..

### Ejecucion del script del SIA ##
cd SIA
mkdir -p Resultados
pip install -r requirements.txt > /dev/null
python Main.py 10 &
pid_py=$!
cd ..

### Espera de que terminen los informes
mkdir -p Resultados
wait $pid_cv
wait $pid_py
cp SIA/Resultados/Compilado.xlsx Resultados/

echo "Done"

