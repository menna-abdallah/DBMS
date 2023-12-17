#! /bin/bash
function connection {
select option in "create table" "select" "insert" "update" "remove" "truncate" "exit"
do
	case $option in 
		"create table")
			echo "$(pwd)"
			source ../../create_table.sh
			break
			;;
		"select")
			source ../../select.sh
			;;
		"insert")
			source ../../insert.sh
			;;
		"update")
			source ../../table_update.sh
			;;
		"remove")
			source ../../delete_table.sh
			;;
		"truncate")
			source ./truncate.sh
			;;
		"exit")
			exit
			;;
		*)
			echo "not valid option"
			;;
		esac
	done
}
read -p " Enter DataBase Name: " dbname

if [ ! -d $(pwd)/$dbname ];
then
	echo "$dbname not exist"
else
	source  cd $dbname
	 connection

fi
