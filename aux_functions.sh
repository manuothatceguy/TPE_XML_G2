#!/bin/bash

function remove_schema(){
    # Se eliminan las líneas que contienen el schema de los archivos descargados
    sed -i '/xmlns="http:\/\/www.sportradar.com\/nascar-ot3"/d' $1
    sed -i '/xmlns="http:\/\/www.sportradar.com\/nascar-ot3"/d' $2
}

function clean_prev(){
    # Se eliminan los archivos descargados
    rm drivers_list.xml drivers_standings.xml nascar_data.xml
}