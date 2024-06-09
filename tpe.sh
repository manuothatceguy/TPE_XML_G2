#!/bin/bash
# tpe.sh

# TRABAJO PRÁCTICO ESPECIAL - Diseño y procesamiento de documentos XML - Instituto Tecnológico de Buenos Aires
# Autores: Alvarez, María Victoria; Nogueira, Santiago; Othatceguy, Manuel; Pepe, Santino
# Fecha de entrega: 12/06/2024

ERROR=""

if [ -z "$SPORTRADAR_API" ]
then
    echo "¡Error! La clave de la API no está definida."
    ERROR="$ERROR<error>Clave de la API no definida</error>"
fi

# aux_functions.sh contiene las funciones auxiliares utilizadas (por ejemplo: remove_schema)
source aux_functions.sh

if [ $# -ne 2 ]
then
    echo "¡Cantidad de argumentos inválida! Por favor ingrese únicamente dos argumentos."
    ERROR="$ERROR<error>Cantidad de argumentos inválida</error>"
fi

# Para mejorar la claridad del código, se define la variable year para guardar el valor de $1
year=$1

# Validar que $1 sea mayor o igual a 2013 y menor o igual a 2024
check_range $year

if [ $? -ne 0 ]
then
    echo "¡Valor fuera de rango! Por favor ingrese un valor entre 2013 y 2024"
    ERROR="$ERROR<error>Año fuera de rango</error>"
    let ERROR_CODE=$ERROR_CODE+4
fi

# Misma razón de la definición de variable type que en la variable year
type=$2

# Validar que $2 sea "sc", "xf", "cw", "go" o "mc"
check_type $type

if [ $? -ne 0 ]
then
    echo "¡Valor inválido! Por favor ingrese un valor entre 'sc', 'xf', 'cw', 'go' o 'mc'"
    ERROR="$ERROR<error>Tipo de carrera inválido</error>"
fi

if [ -z "$ERROR" ]
then
    
    
    URL_Drivers="https://api.sportradar.com/nascar-ot3/${type}/${year}/drivers/list.xml?api_key=${SPORTRADAR_API}"
    URL_Standings="https://api.sportradar.com/nascar-ot3/${type}/${year}/standings/drivers.xml?api_key=${SPORTRADAR_API}"

    # Se define el nombre del archivo que se descargará
    drivers="drivers_list.xml" 
    standings="drivers_standings.xml"
    download_file $drivers $URL_Drivers

    if [ $? -ne 0 ]
    then
        echo "¡Error al descargar el archivo drivers_list.xml!"
        ERROR="$ERROR<error>Error al descargar el archivo drivers_list.xml</error>"
    fi

    sleep 2 # Respetando el "update frequency" de la API

    download_file $standings $URL_Standings

    if [ $? -ne 0 ]
    then
        echo "¡Error al descargar el archivo drivers_standings.xml!"
        ERROR="$ERROR<error>Error al descargar el archivo drivers_standings.xml</error>"
    fi

    if [ -z "$ERROR" ] # Si no falló la descarga de archivos
    then
        remove_namespace $drivers $standings
        # Se llama a los parsers para que hagan su trabajo, se asume que están correctamente instalados.
        call_xquery "extract_nascar_data.xq" "extract_nascar_data.xml"

        parse_xsd "extract_nascar_data.xml" "nascar_data.xml" 

        # Se borran los archivos temporales o de ejecuciones previas
        clean_prev

        mkdir external
        mv drivers_list.xml drivers_standings.xml external/
    else
        # Se crea el archivo XML con los errores únicamente
        echo "<nascar_data xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
       xsi:noNamespaceSchemaLocation=\"nascar_data.xsd\">$ERROR</nascar_data>" > nascar_data.xml
    fi
else
    # Se crea el archivo XML con los errores únicamente
    echo "<nascar_data xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
       xsi:noNamespaceSchemaLocation=\"nascar_data.xsd\">$ERROR</nascar_data>" > nascar_data.xml
fi
# Se genera el archivo FO y se lo convierte a PDF, sea con o sin errores

generate_fo "nascar_data.xml" "generate_fo_alternativo.xsl" "nascar_page.fo"

generate_pdf "nascar_page.fo" "nascar_report.pdf"

