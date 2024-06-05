#!/bin/bash

# vars.sh contiene las variables de entorno utilizadas (por ejemplo: SPORTRADAR_API)
source vars.sh
# aux_functions.sh contiene las funciones auxiliares utilizadas (por ejemplo: remove_schema)
source aux_functions.sh

# Se define la función main que corre el programa, 
# se usa esta función para evitar que el script corra si es que se descargó incompleto
function main(){
    
    # Se borran archivos de ejecuciones anteriores
    clean_prev

    # Validar que $1 sea mayor o igual a 2013 y menor o igual a 2024
    while [[ $1 -lt 2013 || $1 -gt 2024 ]]; do
        echo "¡Valor fuera de rango! Por favor ingrese un valor entre 2013 y 2024:"
        read -r $1
    done

    # Para mejorar la claridad del código, se define la variable year para guardar el valor de $1
    year=$1

    # Validar que $2 sea "sc", "xf", "cw", "go" o "mc"
    while [[ $2 != "sc" && $2 != "xf" && $2 != "cw" && $2 != "go" && $2 != "mc" ]]; do
        echo "¡Valor inválido! Por favor ingrese un valor entre 'sc', 'xf', 'cw', 'go' o 'mc':"
        read -r $2
    done

    # Misma razón de la definición de variable type que en la variable year
    type=$2

    URL_Drivers="https://api.sportradar.com/nascar-ot3/${type}/${year}/drivers/list.xml?api_key=${SPORTRADAR_API}"
    URL_Standings="https://api.sportradar.com/nascar-ot3/${type}/${year}/standings/drivers.xml?api_key=${SPORTRADAR_API}"
    
    # Se define el nombre del archivo que se descargará
    drivers="drivers_list.xml" 
    standings="drivers_standings.xml"

    # Se hacen las consultas correspondientes, se anula la salida estándar.
    curl -o $drivers $URL_Drivers &> /dev/null
    curl -o $standings $URL_Standings &> /dev/null

    remove_schema $drivers $standings

    # Se llama a los parsers para que hagan su trabajo, se asume que están correctamente instalados.
    # java net.sf.saxon.Query extract_nascar_data.xq 
    
    
}


