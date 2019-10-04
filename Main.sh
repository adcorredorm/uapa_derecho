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
./ext.sh > /dev/null &
pid_cv=$!
cd ..

### Ejecucion del script del SIA ##
cd SIA
mkdir -p Resultados
pip install -r requirements.txt > /dev/null
python Main.py 1 > logs &
pid_py=$!
cd ..

### Espera de que terminen los informes
mkdir -p Resultados
echo "Esperando"
wait $pid_py
echo "Termino sia"
cp SIA/Resultados/Compilado.xlsx Resultados/
wait $pid_cv
echo "Termino cvlac"

echo "Done"

