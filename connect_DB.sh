#! /bin/bash
shopt -s extglob 
export LC_COLLATE=C
function connection {
select option in "create table" "select" "insert" "update" "remove" "truncate" "exit"
do
	case $option in 
		"create table")
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
			source ./update.sh
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
flag=0
while [ $flag = 0 ]
do
if [ ! -d $(pwd)/$dbname ];
then
	read -p"$dbname not exist, please enter name of again : " dbname
else
flag=1
	source  cd $dbname
	 connection

fi
done
