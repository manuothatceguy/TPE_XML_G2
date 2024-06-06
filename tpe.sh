#!/bin/bash

# TRABAJO PRÁCTICO ESPECIAL - Diseño y procesamiento de documentos XML - Instituto Tecnológico de Buenos Aires
# Autores: Alvarez, María Victoria; Nogueira, Santiago; Othatceguy, Manuel; Pepe, Santino
# Fecha de entrega: 12/06/2024

# vars.sh contiene las variables de entorno utilizadas (por ejemplo: SPORTRADAR_API)
source vars.sh
# aux_functions.sh contiene las funciones auxiliares utilizadas (por ejemplo: remove_schema)
source aux_functions.sh

if [ $# -ne 2 ]
then
    echo "¡Cantidad de argumentos inválida! Por favor ingrese únicamente dos argumentos."
    ERROR="$ERROR<error>Cantidad de argumentos inválida</error>"
    ERROR_CODE=1
fi



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
    ERROR="$ERROR<error>Año fuera de rango</error>"
    ERROR_CODE=2
fi

# Misma razón de la definición de variable type que en la variable year
type=$2

# Validar que $2 sea "sc", "xf", "cw", "go" o "mc"
check_type $type
if [ $? -ne 0 ]
then
    echo "¡Valor inválido! Por favor ingrese un valor entre 'sc', 'xf', 'cw', 'go' o 'mc'"
    ERROR="$ERROR<error>Tipo de carrera inválido</error>"
    ERROR_CODE=3
fi

if [ $ERROR_CODE -eq 0 ]
then
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
        ERROR="$ERROR<error>Error al descargar el archivo drivers_list.xml</error>"
        ERROR_CODE=4
    fi

    curl -o $standings $URL_Standings &> /dev/null

    if [ $? -ne 0 ]
    then
        echo "¡Error al descargar el archivo drivers_standings.xml!"
        ERROR="$ERROR<error>Error al descargar el archivo drivers_standings.xml</error>"
        ERROR_CODE=5
    fi

    if [ $ERROR_CODE -eq 0 ] # Si no falló la descarga de archivos
    then
        remove_namespace $drivers $standings
        # Se llama a los parsers para que hagan su trabajo, se asume que están correctamente instalados.
        java net.sf.saxon.Query extract_nascar_data.xq > extract_nascar_data.xml 

        java dom.Writer -v -n -s -f extract_nascar_data.xml > nascar_data.xml 

        # Se borran los archivos temporales
        rm nascar_page.fo extract_nascar_data.xml 
        mkdir external
        mv drivers_list.xml drivers_standings.xml external/
    fi
    else
        # Se crea el archivo XML con los errores únicamente
        echo "<nascar_data xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
       xsi:noNamespaceSchemaLocation=\"nascar_data.xsd\">$ERROR</nascar_data>" > nascar_data.xml

fi
# Se genera el archivo FO y se lo convierte a PDF, sea con o sin errores

java net.sf.saxon.Transform -s:nascar_data.xml -xsl:generate_fo.xsl -o:nascar_page.fo 

./fop/fop -fo nascar_page.fo -pdf nascar_report.pdf 