#!/bin/sh

convert=/home/renaud/application/mine/rolisteam-character-sheets/charactersheets/fr/convertSheet.py

files=`find . -name "*.rcs" | awk -F '\\\./' '{print $2}'`
for line in `echo $files`; 
do
    if [ $line != ".rcs" ]
    then
        echo "Processing $line" 
        name=`echo $line | awk -F '.' '{print $1}'`; 
        rm ${name}_fixed.rcs
        $convert -i $line -o ${name}_fixed.rcs -c; 
        mv ${name}_fixed.rcs $line
    fi
done
