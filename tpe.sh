#!/bin/bash

# TRABAJO PRÁCTICO ESPECIAL - Diseño y procesamiento de archivos XML - Instituto Tecnológico de Buenos Aires
# Autores: Alvarez, María Victoria; Nogueira, Santiago; Othatceguy, Manuel; Pepe, Santino
# Fecha de entrega: 12/06/2024

if [ $# -ne 2 ]
then
    echo "¡Cantidad de argumentos inválida! Por favor ingrese únicamente dos argumentos."
    exit 1
fi

# vars.sh contiene las variables de entorno utilizadas (por ejemplo: SPORTRADAR_API)
source vars.sh
# aux_functions.sh contiene las funciones auxiliares utilizadas (por ejemplo: remove_schema)
source aux_functions.sh

# Se elimina el archivo error.log si existiese de una ejecución previa
if [ -e error.log ]
then
    rm error.log
fi

# Para mejorar la claridad del código, se define la variable year para guardar el valor de $1
year=$1

# Validar que $1 sea mayor o igual a 2013 y menor o igual a 2024
check_range $year

if [ $? -ne 0 ]
then
    echo "¡Valor fuera de rango! Por favor ingrese un valor entre 2013 y 2024"
    exit 2
fi

# Misma razón de la definición de variable type que en la variable year
type=$2

# Validar que $2 sea "sc", "xf", "cw", "go" o "mc"
check_type $type
if [ $? -ne 0 ]
then
    echo "¡Valor inválido! Por favor ingrese un valor entre 'sc', 'xf', 'cw', 'go' o 'mc'"
    exit 3
fi

URL_Drivers="https://api.sportradar.com/nascar-ot3/${type}/${year}/drivers/list.xml?api_key=${SPORTRADAR_API}"
URL_Standings="https://api.sportradar.com/nascar-ot3/${type}/${year}/standings/drivers.xml?api_key=${SPORTRADAR_API}"

# Se define el nombre del archivo que se descargará
drivers="drivers_list.xml" 
standings="drivers_standings.xml"

# Se hacen las consultas correspondientes, se anula la salida estándar.
curl -o $drivers $URL_Drivers &> /dev/null

if [ $? -ne 0 ]
then
    echo "¡Error al descargar el archivo drivers_list.xml!"
    exit 4
fi

curl -o $standings $URL_Standings &> /dev/null

if [ $? -ne 0 ]
then
    echo "¡Error al descargar el archivo drivers_standings.xml!"
    exit 5
fi

remove_namespace $drivers $standings
# Se llama a los parsers para que hagan su trabajo, se asume que están correctamente instalados.
java net.sf.saxon.Query extract_nascar_data.xq > extract_nascar_data.xml 2>> error.log

java dom.Writer -v -n -s -f extract_nascar_data.xml > nascar_data.xml 2>> error.log

java net.sf.saxon.Transform -s:nascar_data.xml -xsl:generate_fo.xsl -o:nascar_page.fo 2>> error.log

./fop/fop -fo nascar_page.fo -pdf nascar_report.pdf 2>> error.log

# Se borran los archivos temporales
rm nascar_page.fo extract_nascar_data.xml 
rm drivers_list.xml drivers_standings.xml