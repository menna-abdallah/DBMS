#! /usr/bin/bash

shopt -s extglob
LC_COLLATE=C
export $dbname
path=`pwd`

ls "$path/MyDBMS/$dbname" | grep -v '.metadata'

read -p "Enter the name of table you want to update: " tname

#CHECK EXITANCE
if [ ! -f "$path/MyDBMS/$dbname/$tname" ];
then
	echo "There is no table with that name"
else
		
	echo "choose the condition colum:"
	select opt in $(cut -d":" -f1 "$path/MyDBMS/$dbname/$tname.metadata")
	do
    	field_no=$REPLY
    	break
	done

	while true
	do
		read -p "Enter the value you want to update: " value

		# Check if the value exists in the specified column
		if awk -F: -v value="$value" -v field_no="$field_no" '$field_no == value { found=1; exit } END { if (found != 1) exit 1 }' "$path/MyDBMS/$dbname/$tname"; then
			break  # Value found
		else
			echo "There is no such value. Please enter another one."
		fi
	done

	read -p "Enter new value: " value2
	
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
			read -p "Primary key cannot be null. Enter again: " value2
		else
			pkTest=1
		fi

		if [[ $PK =~ [yY] ]]; 
		then
			if awk -v col="$field_no" -F: '{print $col}' "$path/MyDBMS/$dbname/$tname" | grep -q "^$value2$"; 
			then
				read -p "This value isn't unique: " value2
			else
				pkTest=1
			fi
		fi

		if [[ $col_DataType == "int" ]]; then
			if [[ $value2 =~ ^[0-9]+$ ]]; then
				intTest=1
			else
				read -p "This is not an integer value. Enter again: " value2
				continue  # Continue to the next iteration of the loop
			fi
		elif [[ $col_DataType == "string" ]]; then
			if [[ $value2 =~ ^[a-zA-Z_][a-zA-Z0-9_\"[:space:]]*$ || $value2 =~ ^[0][0-9]*$ ]]; then
				strTest=1
			else
				read -p "This is not a string value. Enter again: " value2
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
				echo "Updated Successfully"
				echo "-----------------------Table after updated-----------------------"
				cat "$path/MyDBMS/$dbname/$tname"
	else
				echo "invalid"
	fi	
	
fi
 

				ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
				echo  -n "to connect another schema, "
				source ./connect_DB.sh
		
		
