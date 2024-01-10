#! /bin/bash
shopt -s extglob 
export LC_COLLATE=C

path=`pwd`
function connection {
select option in "create table" "select" "insert" "update" "remove" "truncate" "exit"
do
	case $option in 
		"create table")
			source ./create_table.sh
			break
			;;
		"select")
			source ./select.sh
			;;
		"insert")
			source  ./insert.sh
			echo " To insert new record enter 3 or Enter 7 to Exit"
			;;
		"update")
			source ./table_update.sh
			;;
		"remove")
			source ./delete_table.sh
			;;
		"truncate")
			source ./truncate.sh
			;;
		"exit")
			#cd ../../
			source ./DB.sh
			;;
		*)
			echo "not valid option"
			;;
		esac
	done
	#echo "please Enter operation to do on table or enter 7 to Exit "
}

declare -i db_no=`ls "$path"/MyDBMS | wc -w`
if (( db_no == 0));
then 
	echo " There is no schemas yet!!"
else
echo "your schemas are : " 
ls "$path/MyDBMS"
 
	read -p "Enter DataBase Name: " dbname
	flag=0
	while [ $flag -eq 0 ]
	do
		if [[ -z $dbname ]]
		then 
		read -p "please enter DataBase Name: "  dbname
		elif [ ! -d "$path"/MyDBMS/$dbname ];
		then
			read -p "$dbname not exist, please enter name of again : " dbname
		else
		flag=1
		 # cd "$path"/$dbname
			connection
		fi
	done
fi
fi