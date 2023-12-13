#! /bin/bash

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
