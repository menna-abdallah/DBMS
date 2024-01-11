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
path=`pwd`

ls "$path/MyDBMS/$dbname" | grep -v '.metadata'

echo -e "${LIGHTBLUE}Enter the name of table you want to update: ${ENDCOLOR}" 
read tname

#CHECK EXITANCE
if [ ! -f "$path/MyDBMS/$dbname/$tname" ];
then
	echo -e "${YELLOW}There is no table with that name${ENDCOLOR}"
else
		
	echo -e "${LIGHTBLUE}choose the condition colum: ${ENDCOLOR}"
	select opt in $(cut -d":" -f1 "$path/MyDBMS/$dbname/$tname.metadata")
	do
    	field_no=$REPLY
    	break
	done

	while true
	do
		echo -e "${LIGHTBLUE}Enter the value you want to update: ${ENDCOLOR}" 
		read value

		# Check if the value exists in the specified column
		if awk -F: -v value="$value" -v field_no="$field_no" '$field_no == value { found=1; exit } END { if (found != 1) exit 1 }' "$path/MyDBMS/$dbname/$tname"; then
			break  # Value found
		else
			echo -e "${BLUE}There is no such value. Please enter another one.${ENDCOLOR}"
		fi
	done

	echo -e "${LIGHTBLUE}Enter new value: ${ENDCOLOR}" 
	read value2
	
	col_DataType=$(awk -F: -v field_no="$field_no" '{if ( NR == field_no) {print $2}}' "$path/MyDBMS/$dbname/$tname.metadata")
	PK=$(awk -F: -v field_no="$field_no" '{if ( NR == field_no) {print $3}}' "$path/MyDBMS/$dbname/$tname.metadata")
	oldValue=$value
	colsNum=$(cat "$path/MyDBMS/$dbname/$tname.metadata" |wc -l)

		intTest=1
		pkTest=1
		strtTest=1

	while true
	do
		pkTest=0
		intTest=0
		strTest=0

		if [[ $PK =~ [yY] && $value2 == "" ]]; then
			echo -e "${RED}Primary key cannot be null.${ENDCOLOR}" 
			echo -e "${BLUE}Enter again: ${ENDCOLOR}" 
			read value2
		else
			pkTest=1
		fi

		if [[ $PK =~ [yY] ]]; 
		then
			if awk -v col="$field_no" -F: '{print $col}' "$path/MyDBMS/$dbname/$tname" | grep -q "^$value2$"; 
			then
				echo -e "${YELLOW}This value isn't unique: ${ENDCOLOR}" 
				read value2
			else
				pkTest=1
			fi
		fi

		if [[ $col_DataType == "int" ]]; then
			if [[ $value2 =~ ^[0-9]+$ ]]; then
				intTest=1
			else
				echo -e  "${YELLOW}This is not an integer value ${ENDCOLOR}" 
				echo -e "${BLUE}Enter again: ${ENDCOLOR}" 
				read value2
				continue  # Continue to the next iteration of the loop
			fi
		elif [[ $col_DataType == "string" ]]; then
			if [[ $value2 =~ ^[a-zA-Z_][a-zA-Z0-9_\"[:space:]]*$ || $value2 =~ ^[0][0-9]*$ ]]; then
				strTest=1
			else
				echo -e  "${YELLOW}This is not a string value.${ENDCOLOR}"
				echo -e "${BLUE}Enter again: ${ENDCOLOR}" 
				read value2			
				fi
		fi
		break
	done

	if (( (intTest * pkTest == 1) || (strTest * pkTest == 1) ));
	then
		awk -F: -v oldvalue="$oldValue" -v value2="$value2" -v col="$field_no" '
				BEGIN { OFS=":"; }
				{
				if ($col == oldvalue) {
					$col = value2;
				}
				print $0;
				}' "$path/MyDBMS/$dbname/$tname" > temptable
				mv temptable "$path/MyDBMS/$dbname/$tname"
				echo -e "${GREEN}Updated Successfully${ENDCOLOR}"
				echo -e "${BLUE}-----------------------Table after updated-----------------------${ENDCOLOR}"
				cat "$path/MyDBMS/$dbname/$tname"
	else
				echo -e "${RED}invalid${ENDCOLOR}"
	fi	
	
fi
 
				echo  -n "*******************to connect another schema, "
				source ./connect_DB.sh
		
		
