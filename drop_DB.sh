#!/usr/bin/bash

shopt -s extglob
export LC_COLLATE=C

# get the current path

path=`pwd`

if (( $# == 0 )) ; then
	echo "code"
else 	
	#Check Exitance
	if [ ! -d "$path/MyDBMS/$1" ];
	then
        	echo " there is no DataBase with the name of $1"
	else
		echo "Worrinng You are going to delete $1"
		read -p "press y to continue or n to quite" confirm
		if [ $confirm = 'y' -o $confirm = 'Y' ];
		then
			rm -r $path/MyDBMS/$1
		else
			exit
		fi
	fi
fi
