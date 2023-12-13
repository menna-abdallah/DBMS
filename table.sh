#! /bin/bash

read -p " Enter DataBase Name: " dbname

if [ ! -d MyDBMS/$dbname ];
then
	read -p "$dbname not exsit , Do you want to creat one? (y / n): " opt
	 if [ opt = 'y' -o opt = 'Y' ];
	 then
		 source ../creat_DB.sh
		
		 cd MyDBMS/$dbname
	 else
		source ../DB.sh
	 fi
 else
	 cd MyDBMS/$dbname
fi

select option in "create table" "select" "insert" "update" "remove" "truncate"
do
	case $option in 
		"create table")
			source ./create_table.sh
			;;
		"select")
			source ./select.sh
			;;
		"insert")
			source ./insert.sh
			;;
		"update")
			source ./update.sh
			;;
		"remove")
			source ./remove.sh
			;;
		"truncate")
			source ./truncate.sh
			;;
			*)
				echo "not valid option"
				;;
		esac
	done
