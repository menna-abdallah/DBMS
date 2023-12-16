#! /bin/bash
function connection {
select option in "create table" "select" "insert" "update" "remove" "truncate" "exit"
do
	case $option in 
		"create table")
			source ../../create_table.sh
			echo " created succesfully"
			`ls $(pwd)/MyDBMS/$dbname `
			break
			;;
		"select")
			source ../../select.sh
			;;
		"insert")
			source ../../insert.sh
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

if [ ! -d $(pwd)/MyDBMS/$dbname ];
then
	echo "$dbname not exist"
else
	source  cd ./MyDBMS/$dbname
	 connection
fi
