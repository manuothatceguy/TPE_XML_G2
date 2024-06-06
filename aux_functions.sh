#!/bin/bash

function remove_namespace(){
    # Se eliminan las líneas que contienen el namespace de los archivos descargados
    
    sed -i 's/xmlns="http:\/\/feed.elasticstats.com\/schema\/nascar\/series-v2.0.xsd"//g' $1
    sed -i 's/<?xml-stylesheet type="text\/xsl" charset="UTF-8" href="\/xslt\/nascar\/series-v2.0.xsl"?>//g' $1
    sed -i 's/xmlns="http:\/\/feed.elasticstats.com\/schema\/nascar\/standings-v2.0.xsd"//g' $2
    sed -i 's/<?xml-stylesheet type="text\/xsl" charset="UTF-8" href="\/xslt\/nascar\/standings-v2.0.xsl"?>//g' $2
}

function check_range(){
    # Se valida que el año ingresado esté en el rango 2013-2024
    if [[ $1 -lt 2013 || $1 -gt 2024 ]]
    then
        return 1
    else
        return 0
    fi
}

function check_type(){
    if [[ $1 != "sc" && $1 != "xf" && $1 != "cw" && $1 != "go" && $1 != "mc" ]]
    then
        return 1
    else
        return 0
    fi
}
