### Recolectando la informacion necesaria para los scripts ##
cd controlador
pip install -r requirements.txt > /dev/null
python separator.py
cp dnis.txt ../SIA/
cp dnis.txt ../colciencias/enlaces/
cd ..

user=`head -1 credenciales.txt`
pass=`head -2 credenciales.txt | tail -1`
export SIAUSER=$user
export SIAPASS=$pass

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
python Main.py 50 &
pid_py=$!
cd ..

### Espera de que terminen los informes
mkdir -p Resultados
wait $pid_cv
mkdir -p Resultados/parcial
cp colciencias/resultados/* Resultados/parcial
cd controlador
python joiner.py > /dev/null
cd ..
mv Resultados/parcial/Compilado_cvlac.xlsx Resultados/
rm -r Resultados/parcial

wait $pid_py
cp SIA/Resultados/Compilado_SIA.xlsx Resultados/

echo "Done"

