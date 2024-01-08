#! /usr/bin/bash

shopt -s extglob
LC_COLLATE=C
export $dbname
path=`pwd`

ls "$path/MyDBMS/$dbname" | grep -v '.metadata'

read -p " Enter the name of table you want to update: " tname

#CHECK EXITANCE
if [ ! -f "$path/MyDBMS/$dbname/$tname" ];
then
	echo " There is no table with that name"
else
		
	echo "choose the condition colum:"
	select opt in $(cut -d":" -f1 "$path/MyDBMS/$dbname/$tname.metadata")
	do
		field_no=$REPLY
		break
	done	
	read -p " Enter the value you want to update: " value
	check=$(awk -F: -v value="$value" -v field_no="$field_no" '{ if ( $field_no == value ) {print value; print $1}}' "$path/MyDBMS/$dbname/$tname")
	echo $check
	# check=`awk -F: -v value="$value" -v field="$field_no" '{ if ( $field == value ) print 1 }' "$path/MyDBMS/$dbname/$tname"`
	echo $check
	if [[ $check == '0' ]];
	then
		echo "there is no such value"
	else
		read -p "Enter new value: " value2
	fi
	col_DataType=$(awk -F: -v field_no="$field_no" '{if ( NR == field_no) {print $2}}' "$path/MyDBMS/$dbname/$tname.metadata")
	PK=$(awk -F: -v field_no="$field_no" '{if ( NR == field_no) {print $3}}' "$path/MyDBMS/$dbname/$tname.metadata")
	oldValue=$value
	colsNum=$(cat "$path/MyDBMS/$dbname/$tname.metadata" |wc -l)
	if  [[ $value2 == "" ]];
	then
		echo "can't be null"
	else
		intTest=1
		pkTest=1
		strtTest=1
		
	if [[ $col_DataType == "int" ]]
	then       
		if [[ $value2 =~ ^[0-9]*$ ]];
		then
			intTest=1
		else
			echo  "this is not an integer value"
			intTest=0
		fi
	else 
		if [[ $value2 =~ ^[a-zA-Z_][a-zA-Z0-9_" "]*$ || $value2 =~ ^[0][0-9]*$  ]] ;
		then
			strTest=1
		else
			echo  "this is not an string value"
			strTest=0
		fi
	fi
		
	if [[ $PK =~ [yY] ]]; 
	then
		if awk -v col="$field_no" -F: '{print $col}' "$path/MyDBMS/$dbname/$tname" | grep -q "^$value2$"; 
		then
			echo "This value isn't unique"
			pkTest=0
		else
			pkTest=1
		fi
	fi

	if (( (intTest * pkTest == 1) || (strTest * pkTest == 1) ));
	then
		echo "valid value"
		awk -F: -v oldvalue="$oldValue" -v value2="$value2" -v col="$field_no" '
		{
			for (i = 1; i <= NF; i++) 
			{
				if ($i == oldvalue) 
				{
					$i = value2;
				}
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
fi

				ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
				echo  -n "to connect another schema, "
				source ./connect_DB.sh
		
		
