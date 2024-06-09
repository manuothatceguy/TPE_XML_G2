#!/bin/bash
# tpe.sh

# TRABAJO PRÁCTICO ESPECIAL - Diseño y procesamiento de documentos XML - Instituto Tecnológico de Buenos Aires
# Autores: Alvarez, María Victoria; Nogueira, Santiago; Othatceguy, Manuel; Pepe, Santino
# Fecha de entrega: 12/06/2024

# aux_functions.sh contiene las funciones auxiliares utilizadas (por ejemplo: remove_schema)
echo "Trabajo práctico especial - Diseño y procesamiento de documentos XML - Grupo 02"
echo "Iniciando..."
source aux_functions.sh

if [ -z "$SPORTRADAR_API" ]
then
    echo "¡Error! La clave de la API no está definida."
    ERROR="<error>API KEY not defined.</error>"
    create_error_file "$ERROR"
fi

if [ $# -ne 2 ]
then
    echo "¡Cantidad de argumentos inválida! Por favor ingrese únicamente dos argumentos."
    ERROR="<error>Invalid number of arguments.</error>"
    create_error_file "$ERROR"
fi

# Para mejorar la claridad del código, se define la variable year para guardar el valor de $1
year=$1

# Validar que $1 sea mayor o igual a 2013 y menor o igual a 2024
check_range $year

if [ $? -ne 0 ]
then
    echo "¡Valor fuera de rango! Por favor ingrese un valor entre 2013 y 2024"
    ERROR="<error>Year out of range.</error>"
    create_error_file "$ERROR"
fi

# Misma razón de la definición de variable type que en la variable year
type=$2

# Validar que $2 sea "sc", "xf", "cw", "go" o "mc"
check_type $type

if [ $? -ne 0 ]
then
    echo "¡Valor inválido! Por favor ingrese un valor entre 'sc', 'xf', 'cw', 'go' o 'mc'"
    ERROR="<error>Invalid race type.</error>"
    create_error_file "$ERROR"
fi

if [ -z "$ERROR" ]
then
    URL_Drivers="https://api.sportradar.com/nascar-ot3/${type}/${year}/drivers/list.xml?api_key=${SPORTRADAR_API}"
    URL_Standings="https://api.sportradar.com/nascar-ot3/${type}/${year}/standings/drivers.xml?api_key=${SPORTRADAR_API}"

    # Se define el nombre del archivo que se descargará
    drivers="drivers_list.xml" 
    standings="drivers_standings.xml"
    echo "Descargando archivos..."
    download_file $drivers $URL_Drivers

    if [ $? -ne 0 ]
    then
        echo "¡Error al descargar el archivo drivers_list.xml!"
        ERROR="<error>drivers_list.xml could not be downloaded</error>"
        create_error_file $ERROR
    fi

    sleep 2 # Respetando el "update frequency" de la API

    download_file $standings $URL_Standings

    if [ $? -ne 0 ]
    then
        echo "¡Error al descargar el archivo drivers_standings.xml!"
        ERROR="<error>drivers_standings.xml could not be downloaded</error>"
        create_error_file $ERROR
    else
        echo "Archivos descargados con éxito. Se procede con la transformación!"
    fi

fi

if [ -z "$ERROR" ] # Si no falló la descarga de archivos
    then
        echo "Eliminando namespaces..."
        remove_namespace $drivers $standings

        # Se llama a los parsers para que hagan su trabajo, se asume que están correctamente instalados.
        echo "Transformando archivos..."
        query "extract_nascar_data.xq" "extract_nascar_data.xml"

        echo "Generando archivo XML..."
        java dom.Writer -v -n -s -f extract_nascar_data.xml > nascar_data.xml 


        # Se borran los archivos temporales o de ejecuciones previas
        clean_prev

        mkdir external
        mv drivers_list.xml drivers_standings.xml external/
fi

if [ -n "$ERROR" ]
then
    create_error_file $ERROR
fi

# Se genera el archivo FO y se lo convierte a PDF, sea con o sin errores
echo "Generando archivo FO y PDF..."
generate_fo "nascar_data.xml" "generate_fo.xsl" "nascar_page.fo"

# Se genera el PDF con Apache FOP
generate_pdf "nascar_page.fo" "nascar_report.pdf"
echo "¡Proceso finalizado con éxito!"


