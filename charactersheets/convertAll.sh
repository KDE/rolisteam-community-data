#!/bin/sh

set -e

convert=/home/renaud/application/mine/rolisteam-character-sheets/charactersheets/fr/convertSheet.py

files=`find . -name "*.rcs" | grep -v fixed | awk -F '\\\./' '{print $2}'`
for line in `echo $files`; 
do
    if [ $line != ".rcs" ]
    then
        echo "Processing $line" 
        name=`echo $line | awk -F '.' '{print $1}'`; 
        rm -f ${name}_fixed.rcs
        $convert -i $line -o ${name}_fixed.rcs -c;
       if [ $? -ne 0 ]
       then
           exit 1
       fi
       mv ${name}_fixed.rcs $line
    fi
done
