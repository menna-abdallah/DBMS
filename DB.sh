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

echo  `pwd`

# start select

select choice in "Creat New DataBase" "List Your DataBase" "Drop Your DataBase" "Connect A DataBAse" "Exit"
do
	case $choice in
  	"Creat New DataBase")
  # ./create_db.sh
  	;;
	"List Your DataBase")
  	ls `pwd`
  	;;

	"Drop Your DataBase")
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


