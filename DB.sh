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

# start select

select choice in "Creat New DataBase" "List Your DataBase" "Drop Your DataBase" "Connect A DataBAse" "Exit"
do
	case $choice in
  	"Creat New DataBase")
	
		source ../creat_DB.sh
  	;;
	"List Your DataBase")
		ls $(pwd)
  	;;

	"Drop Your DataBase")
		source ../drop_DB.sh $@
 	 ;;

 	 "Connect A DataBAse")

  	;;

	"Exit")
		exit
	;;
  	*)
  	echo "Please, select a suitable action"
  	;;
	esac
done


