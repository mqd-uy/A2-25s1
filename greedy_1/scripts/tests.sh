#!/bin/bash

#set -x
BUILD_FOLDER=./build
FOLDER=./


TEST_FOLDER=./Tests
JAVAFILE=$FOLDER/Main.java
CPPFILE=$FOLDER/main.cpp

# borrando resultados anteriores
find $TEST_FOLDER -name "*.own.txt" -type f -delete
# echo "Empezando las pruebas"
du $TEST_FOLDER/*.in.txt | sort -g |
while read filesize filename; do
    Ts="$(date +%s)"
    Tmm="$(date +%s%3N)"
    if [ -f "$CPPFILE" ]; then
        $BUILD_FOLDER/main.out < $filename > ${filename/in/own}
    else 
        java Main < $filename > ${filename/in/own}
    fi
    Ts="$(($(date +%s)-Ts))"
    Tmm="$(($(date +%s%3N)-Tmm))"
    echo "$filename : $Ts segundos | $Tmm milisegundos"
    diff -Z -B ${filename/in/out} ${filename/in/own} > /dev/null

    if [ $? -eq 0 ]; then
        echo -e "\e[32m${filename} - OK\e[0m"
        continue
    else
        echo -e "\e[31m${filename} - FAIL\e[0m"
        exit 1
    fi
done || exit 1