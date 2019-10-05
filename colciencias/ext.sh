############### líneas que se repitieron mucho ##################
# sed -i 's/A/B/g' file ----> cambia A por B en el archivo 'file'
# sed -i ':a;N;$!ba;s/\n/;/g' file ----> cambia salto de línea (\n) por ; en el archivo 'file', los flags del inicio permiten trabajar con saltos de línea
# sed -i '/inicio/,/fin/{s/;/,/g}' file ----> cambia ; por , a todo lo que se encuentre entre las palabras inicio y fin del archivo file
# sed -i '/</d' file ----> elimina todas las filas que tengan < del archivo file
# sed -i '/^[[:space:]]*$/d' file ----> quita todas las líneas vacias
# sed -i -e "s/^/$ide/" "file" ----> pone $ide (la variable ide) al comienzo de cada línea del archivo file  
#grep -na ^$ file ----> muestra los números de línea en los que está $^ del archivo file
# cut -f1 -d: file ---->recorta el archivo file donde hay :
# tac file ----> invierte el orden del archivo file


#Consigue los enlaces
rm enlaces/output.txt 2> /dev/null
cd enlaces
python3 mainCvLac.py  > /dev/null # Hecho por Daniel Escobar
cd ..
sed 's/,.*//' enlaces/output.txt > cedulas
sed 's/^.*\(,.*\)/\1/g' enlaces/output.txt | sed 's/,//g' > links

#Arregla el archivo para buscar únicamente las cedulas que si tienen link
grep -na ^$ links | cut -f1 -d: | tac >links1
x=$(wc -l links1 | cut -f1 -d\ )
if [ $x -gt 0 ]
  then
  for (( c=1 ; c<=$x ; c++ ))
  do
    y=$(sed "${c}q;d" links1)
    sed -i "${y}d" links
    sed -i "${y}d" cedulas
  done
fi
rm links1

#Guarda en p el link y en ide la cédula de un registro
t=$(wc -l links | cut -f1 -d\ )
for (( l=1 ; l<=$t ; l++ ))
do
  p=$(sed "${l}q;d" links)
  ide=$(sed "${l}q;d" cedulas)

echo "col: "$l"/"$t" -- "$ide


#Descarga el html del link
curl -s -k $p > cvlac.txt

sed -i 's/&#.....;//g' cvlac.txt #Quita caracteres raros
sed -i 's/&#....;//g' cvlac.txt #Quita caracteres raros
sed -i 's/&#...;//g' cvlac.txt #Quita caracteres raros
sed -i 's/\r//g' cvlac.txt #Quita espacios de windows
sed -i '/chulo.jpg/d' cvlac.txt #Quita los chulos
sed -i 's/^[ \t]*//' cvlac.txt #Quita los espacios del final de cada línea
sed -i 's/\&nbsp//g' cvlac.txt #Quita ese espacio raro
sed -i 's/\s*$//' cvlac.txt #Quita los espacios del inicio de cada línea



############################################################################################
##########################           RECONOCIMIENTOS            ############################
############################################################################################

sed '0,/^<td><h3 >Reconocimientos<\/h3><\/td>$/d' cvlac.txt > rec
sed -i '/<\/table>/,$d' rec #Guarda en tit los titulos del html
######### Acomoda la estructura de los idiomas en un archivo separado por comas ############
sed -i ':a;N;$!ba;s/<td><li>/soyeliniciodelreconocimiento\n/g' rec
sed -i ':a;N;$!ba;s/<\/li><\/td>/\nsoyelfindelreconocimiento/g' rec
awk ' /^soyeliniciodelreconocimiento$/ {inside=1; sep=""; next}
      /^soyelfindelreconocimiento$/   {inside=0; print ""; next}
      inside         {printf sep""$0; sep=" "; next}
                     {print}' rec > rec.temp
sed ':a;N;$!ba;s/;//g' rec.temp > rec
sed -i ':a;N;$!ba;s/ - Enerode /;Enero /g' rec
sed -i ':a;N;$!ba;s/ - Febrerode /;Febrero /g' rec
sed -i ':a;N;$!ba;s/ - Marzode /;Marzo /g' rec
sed -i ':a;N;$!ba;s/ - Abrilde /;Abril /g' rec
sed -i ':a;N;$!ba;s/ - Mayode /;Mayo /g' rec
sed -i ':a;N;$!ba;s/ - Juniode /;Junio /g' rec
sed -i ':a;N;$!ba;s/ - Juliode /;Julio /g' rec
sed -i ':a;N;$!ba;s/ - Agostode /;Agosto /g' rec
sed -i ':a;N;$!ba;s/ - Septiembrede /;Septiembre /g' rec
sed -i ':a;N;$!ba;s/ - Octubrede /;Octubre /g' rec
sed -i ':a;N;$!ba;s/ - Noviembrede /;Noviembre /g' rec
sed -i ':a;N;$!ba;s/ - Diciembrede /;Diciembre /g' rec
sed -i ':a;N;$!ba;s/- de /;/g' rec
sed -i 's/\(.*\),/\1;/' rec
sed -i '/</d' rec
sed -i '/^[[:space:]]*$/d' rec
sed -i -e "s/^/$ide;/" "rec"
rm rec.temp


############################################################################################
##########################            TRADUCCIONES              ############################
############################################################################################

sed -n '/Inicio traducciones/{h;d;}; H; /Fin traducciones/{x;p;}' cvlac.txt > tra #Guarda en eve los eventos del html
######### Acomoda la estructura de los eventos en un archivo separado por comas ############
sed -i ':a;N;$!ba;s/,\n\n"/\nsoyeliniciodellibro\n/g' tra
sed -i ':a;N;$!ba;s/,\n\n/, /g' tra
sed -i ':a;N;$!ba;s/"\nEn\: /\nsoyelfindellibro\n/g' tra
sed -i '/soyeliniciodellibro/,/soyelfindellibro/{s/;/,/g}' tra
sed -i ':a;N;$!ba;s/\nsoyeliniciodellibro\n/;/g' tra
sed -i ':a;N;$!ba;s/\nsoyelfindellibro\n/;/g' tra
sed -i ':a;N;$!ba;s/\.\n\.\n\.\n<i>Idioma original:<\/i>/;/g' tra
sed -i ':a;N;$!ba;s/\.\n<i>Idioma traducci&oacute;n:<\/i>/;/g' tra
sed -i ':a;N;$!ba;s/\.\n<i>Autor: <\/i>/;/g' tra
sed -i ':a;N;$!ba;s/\.\n<i>Nombre original: <\/i>/;/g' tra
sed -i ':a;N;$!ba;s/\.\n<i>fasc. <\/i>/;/g' tra
sed -i ':a;N;$!ba;s/\.\nv\./;/g' tra

grep -an "<blockquote>" tra | cut -f1 -d: | tac >line.temp
x=$(wc -l line.temp | cut -f1 -d\ )
if [ $x -gt 0 ]
  then
  for (( c=1 ; c<=$x ; c++ ))
  do
    y=$(sed "${c}q;d" line.temp)
    h=$(($y+4))
    y=$(($y-7))
    sed -n -i "p;${y}a soyeliniciodelarticulo" tra
    sed -n -i "p;${h}a soyelfindelarticulo" tra
  done
fi
rm line.temp
sed -i '/soyelfindelarticulo/,/soyeliniciodelarticulo/{//!d}' tra
sed -i ':a;N;$!ba;s/<\/b>/soyalgoraro/g' tra
sed -i 's/<b>//g' tra
sed -i ':a;N;$!ba;s/\.\n20/;20/g' tra
sed -i ':a;N;$!ba;s/\.\n19/;19/g' tra
sed -i '/</d' tra
sed -i '/soyeliniciodelarticulo/d' tra
sed -i '/soyelfindelarticulo/d' tra
sed -i ':a;N;$!ba;s/soyalgoraro\n\n/;/g' tra
sed -i '/^[[:space:]]*$/d' tra
sed -i -e "s/^/$ide;/" "tra"


############################################################################################
##########################               IMPRESO                ############################
############################################################################################

sed -n '/Inicio contenido impreso/{h;d;}; H; /Fin contenido impreso/{x;p;}' cvlac.txt > imp #Guarda en eve los eventos del html
######### Acomoda la estructura de los eventos en un archivo separado por comas ############
sed -i ':a;N;$!ba;s/<i>Nombre <\/i>/Iniciodelimpreso\n/g' imp
sed -i ':a;N;$!ba;s/;\n<i>Tipo<\/i>/\nFindelimpreso\n/g' imp
sed -i '/Iniciodelimpreso/,/Findelimpreso/{s/;/,/g}' imp
sed -i ':a;N;$!ba;s/Iniciodelimpreso\n//g' imp
sed -i ':a;N;$!ba;s/\nFindelimpreso\n/;/g' imp
sed -i ':a;N;$!ba;s/-..-.. 00:00:00.0 //g' imp
sed -i ':a;N;$!ba;s/;\n<i>Medio de circulaci&oacute;n:<\/i>/;/g' imp
sed -i ':a;N;$!ba;s/;\n<i>en el &aacute;mbito<\/i>/;/g' imp
sed -i ':a;N;$!ba;s/;\nen la fecha/;/g' imp
sed -i ':a;N;$!ba;s/;\n<i>disponible en <\/i>/;/g' imp
sed -i '/</d' imp
sed -i '/^[[:space:]]*$/d' imp

sed -i -e "s/^/$ide;/" "imp"


############################################################################################
##########################               COMITES                ############################
############################################################################################

sed -n '/Inicio Participacion comite/{h;d;}; H; /Fin particiacion comite/{x;p;}' cvlac.txt > com #Guarda en eve los eventos del html
######### Acomoda la estructura de los eventos en un archivo separado por comas ############
sed -i ':a;N;$!ba;s/<br>//g' com
grep -an "<i>en:;<\/i> " com | cut -f1 -d: >line.temp
x=$(wc -l line.temp | cut -f1 -d\ )
if [ $x -gt 0 ]
  then
  for (( c=1 ; c<=$x ; c++ ))
  do
    y=$(sed "${c}q;d" line.temp)
    r=$(($y+c+c-1))
    y=$(($y-4+c+c))
    sed -n -i "p;${y}a Aquilosautores"  com
    sed -n -i "p;${r}a findelcomite"  com
  done
fi
rm line.temp
sed -i ':a;N;$!ba;s/\n<i>en:;<\/i> /;/g' com
sed -i ':a;N;$!ba;s/<td><li><b>/iniciodelcomite\n/g' com
sed -i '/findelcomite/,/iniciodelcomite/{//!d}' com
sed -i ':a;N;$!ba;s/,\n\n/, /g' com
sed -i ':a;N;$!ba;s/, Aquilosautores\n/;/g' com
sed -i ':a;N;$!ba;s/<\/b><\/li><\/td>/;/g' com
sed -i ':a;N;$!ba;s/findelcomite//g' com
sed -i ':a;N;$!ba;s/iniciodelcomite//g' com
sed -i '/</d' com
sed -i ':a;N;$!ba;s/;\n\n/;/g' com
sed -i '/^[[:space:]]*$/d' com
sed -i -e "s/^/$ide;/" "com"


############################################################################################
##########################               TITULOS                ############################
############################################################################################

sed '0,/^<td width="100%"><a name="formacion_acad"><\/a>$/d' cvlac.txt > tit 
sed -i '/<\/table>/,$d' tit #Guarda en tit los titulos del html
######### Acomoda la estructura de los idiomas en un archivo separado por comas ############
sed -i ':a;N;$!ba;s/<td><b>//g' tit
sed -i ':a;N;$!ba;s/<\/b>\n/;/g' tit
sed -i ':a;N;$!ba;s/<br \/>\n/\nIniciodealgo\nFindealgo\n/g' tit

awk ' /^Findealgo$/ {inside=1; sep=""; next}
      /^<\/tr>$/   {inside=0; print ""; next}
      inside         {printf sep""$0; sep=""; next}
                     {print}' tit > tit.temp
sed ':a;N;$!ba;s/\nIniciodealgo\n/;/g' tit.temp > tit
sed -i ':a;N;$!ba;s/Iniciodealgo/;/g' tit
rm tit.temp
sed -i ':a;N;$!ba;s/<\/td>//g' tit
sed -i '/</d' tit
sed -i '/^[[:space:]]*$/d' tit
sed -i -e "s/^/$ide;/" "tit"



############################################################################################
##########################               EVENTOS                ############################
############################################################################################

sed -n '/Inicio eventos cientificos/{h;d;}; H; /Fin eventos cientificos/{x;p;}' cvlac.txt > eve #Guarda en eve los eventos del html
######### Acomoda la estructura de los eventos en un archivo separado por comas ############
sed -i ':a;N;$!ba;s/<b>...<\/b>;<i><b>Nombre del evento:;<\/b><\/i>/iniciodelnombredelevento\n/g' eve
sed -i ':a;N;$!ba;s/<b>..<\/b>;<i><b>Nombre del evento:;<\/b><\/i>/iniciodelnombredelevento\n/g' eve
sed -i ':a;N;$!ba;s/<b>.<\/b>;<i><b>Nombre del evento:;<\/b><\/i>/iniciodelnombredelevento\n/g' eve
sed -i ':a;N;$!ba;s/;\n<i>Tipo de evento: <\/i>/\nfindelnombredelevento\n;/g' eve
sed -i '/iniciodelnombredelevento/,/findelnombredelevento/{s/;/,/g}' eve
sed -i ':a;N;$!ba;s/iniciodelnombredelevento\n//g' eve
sed -i ':a;N;$!ba;s/\nfindelnombredelevento\n//g' eve
sed -i ':a;N;$!ba;s/;\n<i>&Aacute;mbito: <\/i>/;/g' eve
sed -i 's/ 00\:00\:00.0,//g' eve
sed -i 's/ 00\:00\:00.0 //g' eve
sed -i ':a;N;$!ba;s/;\n<i>Realizado el:/;/g' eve
sed -i ':a;N;$!ba;s/;\nen /;/g' eve
sed -i ':a;N;$!ba;s/;\n/;/g' eve
sed -i ':a;N;$!ba;s/ ; - /\niniciodelnombredellugar\n/g' eve
sed -i ':a;N;$!ba;s/<ul>\n<li><i>Nombre del producto:<\/i>/iniciodelnombredelproducto\n/g' eve
sed -i ':a;N;$!ba;s/\n<i>Tipo de producto:<\/i>/\nfindelnombredelproducto\n/g' eve
sed -i '/iniciodelnombredelproducto/,/findelnombredelproducto/{s/;/,/g}' eve
sed -i '/iniciodelnombredelproducto/,/findelnombredelproducto/{s/<//g}' eve
sed -i 's/;<\/td>/\nfindelnombredellugar /g' eve
sed -i '/iniciodelnombredellugar/,/findelnombredellugar/{s/;/,/g}' eve
sed -i ':a;N;$!ba;s/\niniciodelnombredellugar\n/;/g' eve
sed -i ':a;N;$!ba;s/\nfindelnombredellugar/;/g' eve
sed -i '/</d' eve
sed -i ':a;N;$!ba;s/iniciodelnombredelproducto\n/;/g' eve
sed -i ':a;N;$!ba;s/\nfindelnombredelproducto\n/;/g' eve
sed -i ':a;N;$!ba;s/\n\n\n;//g' eve
sed -i ':a;N;$!ba;s/\n\n;/;/g' eve
sed -i '/^[[:space:]]*$/d' eve
sed -i -e "s/^/$ide;/" "eve"

############################################################################################
##########################               SOFTWARE               ############################
############################################################################################

sed -n '/Inicio software/{h;d;}; H; /Fin software/{x;p;}' cvlac.txt > sof #Guarda en sof los software del html
######### Acomoda la estructura de los software en un archivo separado por comas ############
grep -an "<i>Nombre comercial:" sof | cut -f1 -d: >line.temp
x=$(wc -l line.temp | cut -f1 -d\ )
if [ $x -gt 0 ]
  then
  for (( c=1 ; c<=$x ; c++ ))
  do
    y=$(sed "${c}q;d" line.temp)
    y=$(($y-2+c-1))
    sed -n -i "p;${y}a Aquilosautores"  sof
  done
fi
rm line.temp
sed -i ':a;N;$!ba;s/,\n\n/, /g' sof
sed -i ':a;N;$!ba;s/, Aquilosautores\n/;/g' sof
sed -i ':a;N;$!ba;s/,\n<i>Nombre comercial\: <\/i>/;/g' sof
sed -i ':a;N;$!ba;s/,\n<i>contrato\/registro\: <\/i>/;/g' sof
sed -i ':a;N;$!ba;s/,\n. En\: /;/g' sof
sed -i ':a;N;$!ba;s/,;\n,/;/g' sof
sed -i ':a;N;$!ba;s/,;\n.<i>plataforma\: /;/g' sof
sed -i ':a;N;$!ba;s/,<\/i>;\n.<i>ambiente: /;/g' sof
sed -i ':a;N;$!ba;s/,<\/i>\n\n/\nsoyelfindelsoftware/g' sof
sed -i ':a;N;$!ba;s/,<\/i>\n\n/\nsoyelfindelsoftware/g' sof
grep -an "<blockquote>" sof | cut -f1 -d: | tac >line.temp
x=$(wc -l line.temp | cut -f1 -d\ )
if [ $x -gt 0 ]
  then
  for (( c=1 ; c<=$x ; c++ ))
  do
    y=$(sed "${c}q;d" line.temp)
    y=$(($y-5))
    sed -n -i "p;${y}a soyeliniciodelsoftware" sof
  done
fi
rm line.temp
sed -i '/soyelfindelsoftware/,/soyeliniciodelsoftware/{//!d}' sof
sed -i ':a;N;$!ba;s/<\/b><\/td>\n<\/tr>\n<tr>\n<td>\n<blockquote>\n\n/;/g' sof
awk ' /^soyeliniciodelsoftware$/ {inside=1; sep=""; next}
      /^soyelfindelsoftware$/   {inside=0; print ""; next}
      inside         {printf sep""$0; sep=""; next}
                     {print}' sof > sof.temp
sed ':a;N;$!ba;s/<b>//g' sof.temp >sof
sed -i '/soyeliniciodelsoftware/d' sof
sed -i '/soyelfindelsoftware/d' sof
sed -i '/</d' sof
sed -i '/^[[:space:]]*$/d' sof
rm sof.temp
sed -i -e "s/^/$ide;/" "sof"



############################################################################################
##########################               IDIOMAS                ############################
############################################################################################

sed '0,/^<td colspan="5"><h3 >Idiomas<\/h3><\/td>$/d' cvlac.txt > idi #Guarda en idi los idiomas del html
sed -i '/<td width="100\%">/,$d' idi
######### Acomoda la estructura de los idiomas en un archivo separado por comas ############
sed -i ':a;N;$!ba;s/<tr>\n<td><li>;//g' idi
sed -i ':a;N;$!ba;s/<\/li><\/td>\n<td>/;/g' idi
sed -i ':a;N;$!ba;s/<\/td>\n<td>/;/g' idi
sed -i ':a;N;$!ba;s/<\/td>\n<\/tr>//g' idi
sed -i '/</d' idi
sed -i '/^[[:space:]]*$/d' idi
sed -i -e "s/^/$ide;/" "idi"

############################################################################################
##########################               LIBROS                 ############################
############################################################################################

sed -n '/Inicio libros/{h;d;}; H; /Fin libros/{x;p;}' cvlac.txt > lib #Guarda en lib los libros del html
######### Acomoda la estructura de los libros en un archivo separado por comas ############
sed -i ':a;N;$!ba;s/,\n\n"/\nsoyeliniciodellibro\n/g' lib
sed -i ':a;N;$!ba;s/,\n\n/, /g' lib
sed -i ':a;N;$!ba;s/"\nEn\: /\nsoyelfindellibro\n/g' lib
sed -i '/soyeliniciodellibro/,/soyelfindellibro/{s/;/,/g}' lib
sed -i ':a;N;$!ba;s/\nsoyeliniciodellibro\n/;/g' lib
sed -i ':a;N;$!ba;s/\nsoyelfindellibro\n/;/g' lib
sed -i ':a;N;$!ba;s/\.;\ned\:/;/g' lib
sed -i ':a;N;$!ba;s/;\n<i>ISBN\:<\/i>;/;/g' lib
sed -i ':a;N;$!ba;s/;\n<i>v\. <\/i>/;/g' lib
sed -i ':a;N;$!ba;s/\n<i>pags\.<\/i>;/;/g' lib
grep -an "<blockquote>" lib | cut -f1 -d: | tac >line.temp
x=$(wc -l line.temp | cut -f1 -d\ )
if [ $x -gt 0 ]
  then
  for (( c=1 ; c<=$x ; c++ ))
  do
    y=$(sed "${c}q;d" line.temp)
    h=$(($y+4))
    g=$(($y+3))
    y=$(($y-6))
    sed -n -i "p;${y}a soyeliniciodelarticulo" lib
    sed -n -i "p;${h}a soyelfindelarticulo" lib
  done
fi
rm line.temp
sed -i '/soyelfindelarticulo/,/soyeliniciodelarticulo/{//!d}' lib
sed -i ':a;N;$!ba;s/<\/b>/soyalgoraro/g' lib
sed -i 's/<b>//g' lib
sed -i '/</d' lib
sed -i '/soyeliniciodelarticulo/d' lib
sed -i '/soyelfindelarticulo/d' lib
sed -i ':a;N;$!ba;s/soyalgoraro\n\n/;/g' lib
sed -i ':a;N;$!ba;s/\n20/;20/g' lib
sed -i ':a;N;$!ba;s/\n19/;19/g' lib
sed -i '/^[[:space:]]*$/d' lib
sed -i -e "s/^/$ide;/" "lib"

############################################################################################
####################               CAPITULOS DE LIBRO            ###########################
############################################################################################

sed -n '/Inicio capitulos libro/{h;d;}; H; /Fin capitulos libro/{x;p;}' cvlac.txt > cap #Guarda en cap los capitulos del html
######### Acomoda la estructura de los capitulos en un archivo separado por comas ############
sed -i ':a;N;$!ba;s/; /, /g' cap
sed -i ':a;N;$!ba;s/,\n\n\n"/;/g' cap
sed -i ':a;N;$!ba;s/"\n/;/g' cap
sed -i ':a;N;$!ba;s/\n\. En\: /;/g' cap
sed -i ':a;N;$!ba;s/;\n<i>ISBN\:<\/i>;/;/g' cap
sed -i ':a;N;$!ba;s/;\n<i>ed\:<\/i>;/;/g' cap
sed -i ':a;N;$!ba;s/\n<i>, v\.<\/i>/;/g' cap
sed -i ':a;N;$!ba;s/\n, p\./;/g' cap
sed -i ':a;N;$!ba;s/\n- / - /g' cap
sed -i ':a;N;$!ba;s/;\n/;/g' cap
sed -i ':a;N;$!ba;s/\n,/;/g' cap
sed -i '/<\/b><br>/d' cap
sed -i '/tulo de libro/d' cap
sed -i ':a;N;$!ba;s/,\n\n/,/g' cap
sed -i 's/<blockquote>/soyeliniciodelcapitulo/g' cap
grep -an "soyeliniciodelcapitulo" cap | cut -f1 -d: | tac >line.temp
x=$(wc -l line.temp | cut -f1 -d\ )
if [ $x -gt 0 ]
  then
  for (( c=1 ; c<=$x ; c++ ))
  do
    y=$(sed "${c}q;d" line.temp)
    y=$(($y+4))
    sed -n -i "p;${y}a soyelfindelcapitulo" cap
  done
fi
rm line.temp
sed -i '/soyelfindelcapitulo/,/soyeliniciodelcapitulo/{//!d}' cap
sed -i '/</d' cap
sed -i '/soyeliniciodelcapitulo/d' cap
sed -i '/soyelfindelcapitulo/d' cap
sed -i '/^[[:space:]]*$/d' cap
sed -i -e "s/^/$ide;/" "cap"


############################################################################################
##########################              ARTICULOS               ############################
############################################################################################

sed -n '/Inicio Articulos/{h;d;}; H; /Fin Articulos/{x;p;}' cvlac.txt > art #Guarda en art los articulos del html
######### Acomoda la estructura de los articulos en un archivo separado por comas ############
sed -i ':a;N;$!ba;s/,\n\n"/\ninicionombrearticulo\n/g' art
sed -i ':a;N;$!ba;s/,\n\n/, /g' art
sed -i ':a;N;$!ba;s/"\n. En\: /\nfinnombredelarticulo\n/g' art
sed -i '/inicionombrearticulo/,/finnombredelarticulo/{s/;/,/g}' art
sed -i ':a;N;$!ba;s/\ninicionombrearticulo\n/;/g' art
sed -i ':a;N;$!ba;s/\nfinnombredelarticulo\n/;/g' art
sed -i ':a;N;$!ba;s/<br>\n<i>/<brr>\n<i>/g' art 
sed -i ':a;N;$!ba;s/;<br>\n/;/g' art 
sed -i ':a;N;$!ba;s/;\n<i>ISSN\:<\/i>;/;/g' art 
sed -i ':a;N;$!ba;s/;\n<i>ISSN\:<\/i>,/;/g' art 
sed -i ':a;N;$!ba;s/;\n<i>ed\:<\/i>;/;/g' art 
sed -i ':a;N;$!ba;s/<brr>\n<i>v.<\/i>/;/g' art 
sed -i ':a;N;$!ba;s/\n<i>fasc.<\/i>/;/g' art 
sed -i ':a;N;$!ba;s/\np\./;/g' art
sed -i ':a;N;$!ba;s/\n-/ - /g' art
sed -i ':a;N;$!ba;s/\n,/;/g' art
sed -i ':a;N;$!ba;s/,\n\n/, /g' art
sed -i ':a;N;$!ba;s/,\n<i>;DOI\:;<\/i>/\nsoyelfindelarticulo\n/g' art
grep -an "<blockquote>" art | cut -f1 -d: | tac >line.temp
x=$(wc -l line.temp | cut -f1 -d\ )
if [ $x -gt 0 ]
  then
  for (( c=1 ; c<=$x ; c++ ))
  do
    y=$(sed "${c}q;d" line.temp)
    y=$(($y-7))
    sed -n -i "p;${y}a soyeliniciodelarticulo\n" art
  done
fi
rm line.temp
sed -i ':a;N;$!ba;s/<\/b>/soyalgoraro/g' art
sed -i 's/<b>//g' art
sed -i '/</d' art
sed -i ':a;N;$!ba;s/soyalgoraro\n\n/;/g' art
sed -i ':a;N;$!ba;s/%//g' art
sed -i '/soyelfindelarticulo/,/soyeliniciodelarticulo/{//!d}' art
awk ' /^soyeliniciodelarticulo$/ {inside=1; sep=""; next}
      /^soyelfindelarticulo$/   {inside=0; print ""; next}
      inside         {printf sep""$0; sep=""; next}
                     {print}' art > art.temp
sed '/^[[:space:]]*$/d' art.temp >art
rm art.temp
sed -i -e "s/^/$ide;/" "art"



############################################################################################
##########################                REDES                 ############################
############################################################################################

sed -n '/Inicio redes de conocimiento/{h;d;}; H; /Fin redes de conocimiento/{x;p;}' cvlac.txt > red #Guarda en red las redes del html
######### Acomoda la estructura de las redes en un archivo separado por comas ############
sed -i ':a;N;$!ba;s/<blockquote>\n\n<i>Nombre de la red <\/i>/;/g' red
sed -i ':a;N;$!ba;s/;\n<i>Tipo de red<\/i>/;/g' red
sed -i ':a;N;$!ba;s/,;\n<i>Creada el\:/;/g' red
sed -i ':a;N;$!ba;s/;\nen /;/g' red
sed -i ':a;N;$!ba;s/ ;\n<i>con <\/i> /;/g' red
sed -i ':a;N;$!ba;s/<\/h3><\/td>\n<\/tr>\n\n<tr>\n<td>\n//g' red
sed -i 's/<td><h3>//g' red
sed -i 's/<\/blockquote>//g' red
sed -i ':a;N;$!ba;s/;\n/;/g' red
sed -i '/</d' red
sed -i '/^[[:space:]]*$/d' red
sed -i -e "s/^/$ide;/" "red"

############################################################################################
#########################              PROTOTIPOS               ############################
############################################################################################

sed -n '/Inicio de prototipos/{h;d;}; H; /Fin de prototipos/{x;p;}' cvlac.txt > pro #Guarda en pro los prototipos del html
######### Acomoda la estructura de los prototipos en un archivo separado por comas ############
grep -an "<i>Nombre comercial:" pro | cut -f1 -d: >line.temp
x=$(wc -l line.temp | cut -f1 -d\ )
if [ $x -gt 0 ]
  then
  for (( c=1 ; c<=$x ; c++ ))
  do
    y=$(sed "${c}q;d" line.temp)
    y=$(($y-2+c-1))
    sed -n -i "p;${y}a Aquilosautores"  pro
  done
fi
rm line.temp

sed -i ':a;N;$!ba;s/,\n\n/, /g' pro
sed -i ':a;N;$!ba;s/,;\n\n\n\n\n\n\n\n<\/blockquote>/;;;/g' pro
sed -i ':a;N;$!ba;s/,;\n\n\n\n\n<br><b>Areas\: <\/b><br>\n\n/;;/g' pro
sed -i ':a;N;$!ba;s/,;\n\n\n<br><b>Palabras\: <\/b><br>\n\n/;/g' pro
sed -i ':a;N;$!ba;s/, \n\n<br><b>Areas\: <\/b><br>\n\n/;/g' pro
sed -i ':a;N;$!ba;s/, \n\n<br><b>Sectores\: <\/b><br>\n\n/;/g' pro
sed -i ':a;N;$!ba;s/,;\n\n\n\n\n\n\n<br><b>Sectores\: <\/b><br>\n\n/;;;/g' pro
sed -i ':a;N;$!ba;s/, \n<\/blockquote>//g' pro
sed -i ':a;N;$!ba;s/, Aquilosautores\n/;/g' pro
sed -i ':a;N;$!ba;s/,\n<i>Nombre comercial\: <\/i>/;/g' pro
sed -i ':a;N;$!ba;s/,\n<i>contrato\/registro\: <\/i>/;/g' pro
sed -i ':a;N;$!ba;s/,\n. En\: /;/g' pro
sed -i ':a;N;$!ba;s/,;\n,/;/g' pro
sed -i ':a;N;$!ba;s/<\/b><\/td>\n<\/tr>\n<tr>\n<td>\n<blockquote>\n\n/;/g' pro
sed -i 's/<b>//g' pro
sed -i 's/<\/i>//g' pro
sed -i '/</d' pro
sed -i '/^[[:space:]]*$/d' pro
sed -i -e "s/^/$ide;/" "pro"

############################################################################################
###############  Copia los resultados de cada CvLAC en un archivo general  #################
############################################################################################

sed -n 'p' art >> articulos
sed -n 'p' cap >> capitulos
sed -n 'p' eve >> eventos
sed -n 'p' lib >> libros
sed -n 'p' sof >> software
sed -n 'p' pro >> prototipos
sed -n 'p' red >> redes
sed -n 'p' idi >> idiomas
sed -n 'p' tit >> titulos
sed -n 'p' com >> comites
sed -n 'p' imp >> impresos
sed -n 'p' tra >> traducciones
sed -n 'p' rec >> reconocimientos
done

rm art cap eve lib sof pro red idi tit com imp tra rec cvlac.txt
rm resultados/* 2> /dev/null 
mv articulos capitulos eventos libros prototipos redes software idiomas titulos comites impresos traducciones reconocimientos resultados
rm cedulas links
