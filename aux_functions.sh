#!/bin/bash
# aux_functions.sh

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

function clean_prev(){
    if [ -e nascar_page.fo ]
    then
        rm nascar_page.fo
    fi

    if [ -e extract_nascar_data.xml ]
    then
        rm extract_nascar_data.xml
    fi

    if [ -d external ]
    then
        rm -rf external
    fi
}

function download_file(){
    # Se descarga el archivo en la URL especificada
    curl -o $1 $2 &> /dev/null
    echo $?
    return $?
}

function call_xquery(){
    # Se llama al parser XQuery para que haga su trabajo
    java net.sf.saxon.Query $1 > $2 
    return $? 
}

function generate_fo(){
    # Se genera el archivo FO
    java net.sf.saxon.Transform -s:$1 -xsl:$2 -o:$3 
    return $?
}

function generate_pdf(){
    # Se genera el PDF
    ./fop/fop -fo $1 -pdf $2 
    return $?
}