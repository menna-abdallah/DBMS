#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
LIGHTBLUE="\e[94m"
ENDCOLOR="\e[0m"

path=$(pwd)
export dbname  # Corrected the variable name
tabel_num=$(ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$' | wc -w )
if [ $tabel_num -eq 0 ]
then
echo -e "${YELLOW}there is no tabels in your schema${ENDCOLOR}"
break
else 
echo -e "${BLUE}Tables in your schema are: ${ENDCOLOR}"
ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
fi
echo -e "${LIGHTBLUE}Enter name of table you want to truncate: ${ENDCOLOR}" 
read table_name  # Corrected variable name

typeset -i flag=0
while [ $flag -eq 0 ]
do
    if [ -f "$path/MyDBMS/$dbname/$table_name" ]
    then
        flag=1
        echo -e "${YELLOW}Are you sure you want to delete table? Y/N: ${ENDCOLOR}" 
        read answer
        typeset -i flag_ans=0
        while [ $flag_ans -eq 0 ]
        do
            if [[ $answer == [Yy] ]]
            then
			flag_ans=1
                echo -e "${GREEN}-----------------table removed successfully--------------------${ENDCOLOR}"
                rm "$path/MyDBMS/$dbname/$table_name"
                rm "$path/MyDBMS/$dbname/$table_name.metadata"
            else
                echo -p "${BLUE}please enter valid choice (Y/N): ${ENDCOLOR}" 
                read answer
            fi
        done
    else
        echo -e "${RED}There is no table with this name${ENDCOLOR}" 
        echo -e"${BLUE}please enter name again: ${ENDCOLOR}" 
        read table_name 
    fi
done
ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
echo  -n "*********************to connect another schema, "
source ./connect_DB.sh
