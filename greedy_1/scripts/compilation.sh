#!/bin/bash

#set -x
BUILD_FOLDER=./build
FOLDER=./

mkdir "$BUILD_FOLDER" 

TEST_FOLDER=./Tests
JAVAFILE=$FOLDER/Main.java
CPPFILE=$FOLDER/main.cpp


echo "Compilando..."
if [ -f "$CPPFILE" ]; then
    echo "Realizado en C++"
    if ! g++ $CPPFILE -o $BUILD_FOLDER/main.out --std=c++11; then
    echo -e "\e[31mERROR en compilacion\e[0m"
    exit 1
    continue
    fi
else 
    echo "Realizado en JAVA"
    if ! javac $JAVAFILE -d $FOLDER -sourcepath $FOLDER; then
    echo -e "\e[31mERROR en compilacion\e[0m"
    exit 1
    continue
    fi
fi
echo "Compilado terminado" 