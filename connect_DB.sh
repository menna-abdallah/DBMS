#! /bin/bash
shopt -s extglob 
export LC_COLLATE=C
echo "Enter the name of the schema : "
ls $pwd

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
			echo " To insert new record enter 3 or Enter 7 to Exit"
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
	echo "please Enter operation to do on table or enter 7 to Exit "
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
