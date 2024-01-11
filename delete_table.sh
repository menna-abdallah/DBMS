#! /usr/bin/bash

shopt -s extglob
LC_COLLATE=C

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
LIGHTBLUE="\e[94m"
ENDCOLOR="\e[0m"

export $dbname
path=$(pwd)
ls "$path/MyDBMS/$dbname" | grep -v '.metadata'
read -p "Enter the name of table you want to delete its data: " tname

#CHECK EXITANCE
if [ ! -f "$path/MyDBMS/$dbname/$tname" ];
then
	echo "${RED}There is no table with that name${ENDCOLOR}"
else
	select del_choice in "Delete all Data" "Delete Rows" "Delete Colums" "EXIT"
	do
		case $del_choice in
			"Delete all Data")
				echo "${YELLOW}Worrinng You are going to delete $tname${ENDCOLOR}"
				echo -e "${BLUE}press y to continue or n to quite: ${ENDCOLOR}" 
				read confirm
				if [ $confirm = 'y' -o $confirm = 'Y' ];
				then
					echo " " > "$path/MyDBMS/$dbname/$tname"
					echo -e "${GREEN}Data Deleted Successfully${ENDCOLOR}"
				else
					exit
				fi		
			;;
			"Delete Rows")
				echo "choose the condition colum:"
				select opt in `cut -d":" -f1 "$path/MyDBMS/$dbname/$tname.metadata"`
				do
					field_no=$REPLY
					break
				done	
				read -p "Enter value you want to delete:  " value
				if [  `grep -F "$value" "$path/MyDBMS/$dbname/$tname" | wc -w` -eq 0 ];
				then
					echo -e "${YELLOW}There is no such value${ENDCOLOR}"	
				else
					if [[ $value =~ ^[0-9]*$ ]];
					then	
						select choice in "greater than" "less than" "equal" "Exit"
							do		
								case $choice in 
									"greater than")
										awk -v value="$value" -v field_no="$field_no" -F: '
										{ 
											if ( $field_no <= value ) print $0 
										}' "$path/MyDBMS/$dbname/$tname" >> "$path/MyDBMS/$dbname/temp" 
										rm "$path/MyDBMS/$dbname/$tname"
										mv "$path/MyDBMS/$dbname/temp"  "$path/MyDBMS/$dbname/$tname"
										
									;;
									"less than")
										awk -v value="$value" -v field_no="$field_no" -F: '
										{ 
											if ( $field_no >= value ) print $0 
										}' "$path/MyDBMS/$dbname/$tname" >> "$path/MyDBMS/$dbname/temp" 
										rm "$path/MyDBMS/$dbname/$tname"
										mv "$path/MyDBMS/$dbname/temp"  "$path/MyDBMS/$dbname/$tname"
									;;
									"equal")
										awk -v value="$value" -v field_no="$field_no" -F: '
										{ 
											if ( $field_no != value ) print $0 
										}' "$path/MyDBMS/$dbname/$tname" >> "$path/MyDBMS/$dbname/temp" 
										rm "$path/MyDBMS/$dbname/$tname"
										mv "$path/MyDBMS/$dbname/temp"  "$path/MyDBMS/$dbname/$tname"
									;;
									"Exit")
										exit
									;;
									*)
										echo -e "${RED}Not valid${ENDCOLOR}"
									;;
								esac	
							done
					else
						awk -v value="$value" -v field_no="$field_no" -F: '
							{ 
								if ($field_no != value) {print $0} 
							}' "$path/MyDBMS/$dbname/$tname" >> "$path/MyDBMS/$dbname/temp" 
							rm "$path/MyDBMS/$dbname/$tname"
							mv "$path/MyDBMS/$dbname/temp"  "$path/MyDBMS/$dbname/$tname"
					fi
				fi
			;;
			"Delete Colums")
				echo "choose the condition colum:"
				select opt in $(cut -d":" -f1 "$path/MyDBMS/$dbname/$tname.metadata")
				do
					field_no=$REPLY
					break
				done
					
			    PK=$(awk -F: -v field_no="$field_no" '{if ( NR == field_no) {print $3}}' "$path/MyDBMS/$dbname/$tname.metadata")
					
				if [[ $PK == "y"  || $PK == "Y" ]];
				then
					echo -e "${YELLOW}you can not delete a primary key${ENDCOLOR}"
				else			                        
					cut -d: -f"$field_no" --complement "$path/MyDBMS/$dbname/$tname" >> "$path/MyDBMS/$dbname/temp" 
					rm "$path/MyDBMS/$dbname/$tname"
					mv "$path/MyDBMS/$dbname/temp"  "$path/MyDBMS/$dbname/$tname"
					
				fi
			;;	
			"EXIT")
				exit
			;;
			*)
				echo -e "${RED}Invalid choice${ENDCOLOR}"
			;;
		esac
	done
fi

ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
echo  -n "to connect another schema, "
source ./connect_DB.sh


