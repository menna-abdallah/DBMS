#!/usr/bin/bash
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
LIGHTBLUE="\e[94m"
ENDCOLOR="\e[0m"
shopt -s extglob
export LC_COLLATE=C

# get the current path
path=`pwd`

#Check Exitance
if [ ! -e "$path"/MyDBMS ];
then
	mkdir "$path"/MyDBMS  
	#cd "$path"/MyDBMS
#else
	#cd "$path"/MyDBMS
fi
#echo "$path"
echo -e "${GREEN}-------------------------Welcome to our Database Managment System-----------------------------------${ENDCOLOR}"

# start select


select choice in "Creat New DataBase" "List Your DataBase" "Drop Your DataBase" "Connect A DataBAse" "Exit"
do
	case $choice in
  	"Creat New DataBase")
			source ./creat_DB.sh
  	;;
	"List Your DataBase")
			echo -e "${BLUE}DataBase schemas are : ${ENDCOLOR}"
			ls "$path/MyDBMS" 
  	;;

	"Drop Your DataBase")
			source ./drop_DB.sh 
 	 ;;

 	 "Connect A DataBAse")
			source ./connect_DB.sh
  	;;

	"Exit")
		exit
	;;
  	*)
			echo -e "${YELLOW}Please, select a suitable action${ENDCOLOR}"
  	;;
	esac
	        echo "please enter your choice or enter 5 to Exit "

done


