#!/usr/bin/bash

shopt -s extglob
export LC_COLLATE=C

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
LIGHTBLUE="\e[94m"
ENDCOLOR="\e[0m"

# get the current path
path=`pwd`

ls "$path"/MyDBMS

echo "Please enter your choice or enter 3 to Exit "
declare -i db_no=`ls "$path"/MyDBMS | wc -w`

select del_choice in "Delete all DataBases" "Delete a specific DataBase" "EXIT"
do
	case $del_choice in
		"Delete all DataBases")
			echo -e "${YELLOW}Worrinng You are going to delete all your DataBase${ENDCOLOR}"
			echo -e " ${YELLOW}press y to continue or n to quite: ${ENDCOLOR}" 
			read confirm
			if [ $confirm = 'y' -o $confirm = 'Y' ];
			then
				if (( db_no == 0));
				then 
					echo -e "${RED}There is no DataBase yet!!${ENDCOLOR}"
				else
					for _db in `ls "$path"/MyDBMS`
					do
						rm -r "$path"/MyDBMS/$_db
					done
					echo -e "${GREEN}All DataBase are deleted${ENDCOLOR}"
				fi
			else
				exit
			fi
			;;

		"Delete a specific DataBase")
			if ((db_no == 0));
			then
				echo -e "${YELLOW}There is no DataBase${ENDCOLOR}"
				break
			else
				ls "$path/MyDBMS"
				echo -e "${LIGHTBLUE}Enter the name of DataBase: ${ENDCOLOR}" 
				read dbname
			fi
			#Check Exitance
			if [ ! -d "$path"/MyDBMS/$dbname ];
			then
				echo -e "${YELLOW}There is no DataBase with the name of $dbname${ENDCOLOR}"
			else
				echo -e "${YELLOW}Worrinng You are going to delete $dbname${ENDCOLOR}"
				echo -e " ${YELLOW}press y to continue or n to quite: ${ENDCOLOR}" 
				read confirm				
			if [ $confirm = 'y' -o $confirm = 'Y' ];
				then
					rm -r "$path"/MyDBMS/$dbname
					echo -e "${GREEN}$dbname removed Successfully${ENDCOLOR}"
					ls "$path/MyDBMS"
				else
					exit
				fi
		fi
		;;

		 "EXIT")
			 source ./DB.sh
			 ;;
			 *)
			 echo -e "${RED}Please, Enter a suitable choice${ENDCOLOR}"
	 esac
 done


				ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
				echo  -n "*************to connect another schema, "
				source ./connect_DB.sh