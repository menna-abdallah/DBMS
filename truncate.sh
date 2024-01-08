#!/bin/bash
path=$(pwd)
export dbname  # Corrected the variable name
tabel_num=$(ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$' | wc -w )
if [ $tabel_num -eq 0 ]
then
echo "there is no tabels in your schema"
break
else 
echo "tables in your schema are: "
ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
fi
read -p "enter name of table you want to truncate: " table_name  # Corrected variable name

typeset -i flag=0
while [ $flag -eq 0 ]
do
    if [ -f "$path/MyDBMS/$dbname/$table_name" ]
    then
        flag=1
        read -p "are you sure you want to delete table? Y/N: " answer
        typeset -i flag_ans=0
        while [ $flag_ans -eq 0 ]
        do
            if [[ $answer == [Yy] ]]
            then
			flag_ans=1
                echo "-----------------table removed successfully--------------------"
                rm "$path/MyDBMS/$dbname/$table_name"
                rm "$path/MyDBMS/$dbname/$table_name.metadata"
            else
                read -p "please enter valid choice (Y/N): " answer
            fi
        done
    else
        read -p "there is no table with this name, please enter name again: " table_name 
    fi
done
ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
echo  -n "to connect another schema, "
source ./connect_DB.sh
