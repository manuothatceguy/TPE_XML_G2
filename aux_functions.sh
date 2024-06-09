#!/bin/bash
# aux_functions.sh

remove_namespace(){
    # Se eliminan las líneas que contienen el namespace de los archivos descargados
    for file in $@
    do
        sed -i 's/xmlns="http:\/\/feed.elasticstats.com\/schema\/nascar\/series-v2.0.xsd"//g' $file
        sed -i 's/<?xml-stylesheet type="text\/xsl" charset="UTF-8" href="\/xslt\/nascar\/series-v2.0.xsl"?>//g' $file
        sed -i 's/xmlns="http:\/\/feed.elasticstats.com\/schema\/nascar\/standings-v2.0.xsd"//g' $file
        sed -i 's/<?xml-stylesheet type="text\/xsl" charset="UTF-8" href="\/xslt\/nascar\/standings-v2.0.xsl"?>//g' $file
    done
}

check_range(){
    # Se valida que el año ingresado esté en el rango 2013-2024
    if [[ $1 -lt 2013 || $1 -gt 2024 ]]
    then
        return 1
    else
        return 0
    fi
}

check_type(){
    if [[ $1 != "sc" && $1 != "xf" && $1 != "cw" && $1 != "go" && $1 != "mc" ]]
    then
        return 1
    else
        return 0
    fi
}

clean_prev(){
    remove_if_exists "nastar_data.xml"

    remove_if_exists "extract_nascar_data.xml"
    
    remove_if_exists "external"

    remove_if_exists "nascar_report.pdf"

    remove_if_exists "nascar_page.fo"
}

remove_if_exists(){
    if [ -e ${1} ]
    then
        rm -rf ${1}
    fi
}

download_file(){
    # Se descarga el archivo en la URL especificada
    curl -o ${1} ${2} &> /dev/null
    return $?
}

query(){
    # Se ejecuta la consulta XQuery
    java net.sf.saxon.Query ${1} > ${2}
    return $?
}

generate_pdf(){
    chmod u+x ./fop/fop
    ./fop/fop -fo ${1} -pdf ${2} &> /dev/null
    return $?
}

generate_fo(){
    # Se genera el archivo .fo
    java net.sf.saxon.Transform -s:${1} -xsl:${2} -o:${3}
    return $?
}

create_error_file(){
    # Se crea el archivo de error
    echo "<nascar_data xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
       xsi:noNamespaceSchemaLocation=\"nascar_data.xsd\">${1}</nascar_data>" > nascar_data.xml
    generate_fo "nascar_data.xml" "generate_fo.xsl" "nascar_page.fo"
    generate_pdf "nascar_page.fo" "nascar_report.pdf"
    exit 1
}