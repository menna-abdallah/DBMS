#! /bin/bash
shopt -s extglob 
export LC_COLLATE=C

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
LIGHTBLUE="\e[94m"
ENDCOLOR="\e[0m"

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
			echo -e "${BLUE}To insert new record enter 3 or Enter 7 to Exit${ENDCOLOR}"
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
			echo -e "${RED}Not valid option${ENDCOLOR}"
			;;
		esac
	done
	#echo "please Enter operation to do on table or enter 7 to Exit "
}

declare -i db_no=`ls "$path"/MyDBMS | wc -w`
if (( db_no == 0));
then 
	echo -e "${YELLOW}There is no schemas yet!!${ENDCOLOR}"
else
echo -e "${BLUE}your schemas are : ${ENDCOLOR}" 
ls "$path/MyDBMS"
 
	echo -e "${LIGHTBLUE}Enter DataBase Name: ${ENDCOLOR}" 
	read dbname
	flag=0
	while [ $flag -eq 0 ]
	do
		if [[ -z $dbname ]]
		then 
		echo -e "${BLUE}Please, Enter DataBase Name: ${ENDCOLOR}" 
		read dbname
		elif [ ! -d "$path"/MyDBMS/$dbname ];
		then
			echo -e "${RED} $dbname not exist${ENDCOLOR}"
		echo -e "${BLUE}Please, Enter DataBase Name again: ${ENDCOLOR}" 
		read dbname		
		else
		flag=1
		 # cd "$path"/$dbname
			connection
		fi
	done
fi
fi