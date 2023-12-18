#!/usr/bin/bash

shopt -s extglob
export LC_COLLATE=C

# get the current path
path=`pwd`

#Check Exitance
if [ ! -e "$path/MyDBMS" ];
then
	mkdir "$path/MyDBMS"
else
	cd "$path/MyDBMS"
fi
echo "-------------------------Welcome to our Database Managment System-----------------------------------"
# start select

select choice in "Creat New DataBase" "List Your DataBase" "Drop Your DataBase" "Connect A DataBAse" "Exit"
do
	case $choice in
  	"Creat New DataBase")
	
		source ../creat_DB.sh
  	;;
	"List Your DataBase")
		echo " DataBase schemas are : "
		ls $(pwd)
  	;;

	"Drop Your DataBase")
		source ../drop_DB.sh $@
 	 ;;

 	 "Connect A DataBAse")
		 source ../connect_DB.sh
  	;;

	"Exit")
		exit
	;;
  	*)
  	echo "Please, select a suitable action"
  	;;
	esac
	        echo "please enter your choice or enter 5 to Exit "

done


