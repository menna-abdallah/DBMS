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
export $dbname
echo "tabels in your database are :"
ls "$path/MyDBMS/$dbname" | grep -v '\.metadata'
read -p "Enter name of tabel:  " tabel_name
typeset -i num=0
function checkdata(){
	if [ "$num" -eq 0 ]
				then
					echo -e "${YELLOW}------------------There is no data in the table yet!!!------------------${ENDCOLOR}"
				else
					echo -e "${BLUE}------------------Selected Data----------------------------${ENDCOLOR}"
					cat "$path/MyDBMS/$dbname/temp"
				fi
}
typeset -i count=1
flag=1
while [ $flag = 1 ]
do
#check existance of tabel 
if [[ $tabel_name = "" ]]
then 
echo -e "${LIGHTBLUE}please enter tabel name:  ${ENDCOLOR}" 
read tabel_name  
   elif [ -e "$path/MyDBMS/$dbname/$tabel_name" ]
	then
	flag=0	
	select option in "select all" "select record" "select column"
	do 
		case $option in
			"select all")
				num=$(cat "$path/MyDBMS/$dbname/$tabel_name" | wc -l )
				cat "$path/MyDBMS/$dbname/$tabel_name" > temp
				checkdata "$num"
				break
				;;
			"select record")
				#cut -d":" -f1  "$tabel_name.metadata" | nl -w1
				echo -e "${LIGHTBLUE}Select one attribute to build your condition on: ${ENDCOLOR}"
				select opt in `cut -d":" -f1 "$path/MyDBMS/$dbname/$tabel_name.metadata"`
				do
					replay=$REPLY	
					echo -e "${LIGHTBLUE}Enter value you want to select:  ${ENDCOLOR}" 
					read value 
					select choice in "greater than"   "less than"   "greater than or equal"  "less than or equal"  "equal"
					do
						case $choice in 
							"greater than")
								# -v  used to assign a value to an awk variable from the shell.
								awk -v value="$value" -v field="$replay" -F: '
								{ 
									if ( $field > value ) { print $0 }
								}					
								' "$path/MyDBMS/$dbname/$tabel_name" > "$path/MyDBMS/$dbname/temp"
								num=$(wc -l < "$path/MyDBMS/$dbname/temp" | awk '{print $1}')
								echo $num
								checkdata "$num"
								break
								;;
							"less than")
								awk -v value="$value" -v field="$replay" -F: '
								{ 
									if ( $field < value ) { print $0 }
								}	
								' "$path/MyDBMS/$dbname/$tabel_name" > temp
								num=$(wc -l < "$path/MyDBMS/$dbname/temp" | awk '{print $1}')
								checkdata "$num"
								break
								;;
							"greater than or equal")
								awk -v value="$value" -v field="$replay" -F: '
								{ 
									if ( $field >= value ) { print $0 }
								}
								' "$path/MyDBMS/$dbname/$tabel_name" > temp
								num=$(wc -l < "$path/MyDBMS/$dbname/temp" | awk '{print $1}')
								checkdata "$num"
								break
								;;
							"less than or equal")
								awk -v value="$value" -v field="$replay" -F: '
								{ 
									if ( $field <= value ) { print $0 }
								}
								' "$path/MyDBMS/$dbname/$tabel_name" > temp
								num=$(wc -l < "$path/MyDBMS/$dbname/temp" | awk '{print $1}')
								checkdata "$num"
								break
								;;

							"equal")
								awk -v value="$value" -v field="$replay" -F: '
								{ 
									if ( $field == value ) { print $0 }
								}
								' "$path/MyDBMS/$dbname/$tabel_name" > temp
								num=$(wc -l < "$path/MyDBMS/$dbname/temp" | awk '{print $1}')
								checkdata "$num"
								break
								;;
								*)
								echo -e "${RED}invalid choice${ENDCOLOR}"
								;;
						esac
						break;
					done
					break;
				done
				;;
			"select column")	
				echo -e "${LIGHTBLUE}please enter the number column you want to retrieve: ${ENDCOLOR}" 
			select opt in `cut -d":" -f1 "$path/MyDBMS/$dbname/$tabel_name.metadata"`
				do
					replay=$REPLY	
				awk -F: -v field="$replay" '{ print $field }' "$path/MyDBMS/$dbname/$tabel_name" > temp
								num=$(wc -l < "$path/MyDBMS/$dbname/temp" | awk '{print $1}')
								checkdata "$num"
				done
				break;
		esac
		break;
	done
	else 
		echo -e "${YELLOW}Table not exist${ENDCOLOR}" 
		echo -e "${BLUE}please enter correct name: ${ENDCOLOR}" 
		read tabel_name
	fi
done
if [ -e "$path/MyDBMS/$dbname/temp" ]
then
rm "$path/MyDBMS/$dbname/temp"
fi
echo -e "${BLUE}------------------tables in schema $dbname are------------------------------${ENDCOLOR}"
ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
echo  -n "************to connect another schema, "
source ./connect_DB.sh
