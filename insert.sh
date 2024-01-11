#! /bin/bash

shopt -s extglob
export LC_COLLATE=C

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
LIGHTBLUE="\e[94m"
ENDCOLOR="\e[0m"

export $dbname
path=`pwd`

function append() {
	if (( $i == $columns ))
	then
		echo  "$field_value" >> "$path/MyDBMS/$dbname/$tabel_name"
	else
		echo -n  "$field_value:" >> "$path/MyDBMS/$dbname/$tabel_name"
	fi
}

function checktype() {

	dataType=`sed -n "${i}p" "$path/MyDBMS/$dbname/$tabel_name.metadata" | cut -d":" -f2`
	ispk=`sed -n "${i}p" "$path/MyDBMS/$dbname/$tabel_name.metadata" | cut -d":" -f3`
	typeset -i check=3
	#start check
	# end check
	flagpk=0
	flagtype=0
	#start add
	while [ $flagpk = 0 ]
	do
		if [[ $ispk == [Yy] ]]
		then
			if [[ $field_value == "" ]]
			then
				echo -e "${RED}primary key can't be null${ENDCOLOR}" 
				echo -e "${BLUE}please enter value : ${ENDCOLOR}" 
				read field_value
			else
			check=`cut -d":" -f$i "$path/MyDBMS/$dbname/$tabel_name" |  awk -F:  -v field_value="$field_value"  'BEGIN{flag=0}{ if( $i==field_value ){flag=1; exit}} END{print flag}' `
			fi	
		fi
		if [[ $check == 3 || $check == 0 ]]
		then 
			while [ $flagtype = 0 ]
			do
			#start check data type
				if [[ $dataType == "string" ]]
				then 
					#validate string
					if [[ $field_value =~ ^[a-zA-Z_][a-zA-Z0-9_" "]*$ || $field_value =~ ^[0][0-9]*$  ]] ;
					then
						flagpk=1
						flagtype=1
						append
					else
						echo -e "${LIGHTBLUE}please enter string value :  ${endcolor}" 
						read field_value
					fi
					# end validation
				else
					#validate int 
					if  [[ $field_value =~ ^[0-9]*$ ]]; 
					then
						flagpk=1
						flagtype=1
						append
					else
						echo -e  "${LIGHTBLUE}please enter int value :  ${ENDCOLOR}" 
						read field_value
					fi
						# end validation
				fi
			done
			# end check data type
		else 
			echo -e "${YELLOW}value isn't unique${ENDCOLOR}" 
			echo -e "${LIGHTBLUE}please enter uniq value : ${ENDCOLOR}" 
			read field_value	
		fi
	done
}

echo -e "${BLUE}tabels in your database are:${ENDCOLOR}" 
ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
echo -e "${LIGHTBLUE}select  name of tabel you want to insert into: ${ENDCOLOR}"  
read tabel_name
flag_tabel=0
while [ $flag_tabel = 0 ]
do
	if [[ $tabel_name == "" ]]
	then
			echo -e "${RED}Tabel name is empty${ENDCOLOR}"
			echo -e "${BLUE}please enter name again: ${ENDCOLOR}" 
			read tabel_name
	elif [ ! -e "$path/MyDBMS/$dbname/$tabel_name" ]
	then 
		echo -e "${YELLOW}Tabel not exist${ENDCOLOR}"
		echo -e "${BLUE}please enter name again: ${ENDCOLOR}" 
		read tabel_name	else 
		flag_tabel=1
		typeset -i i=1
		fields=$(cut -d':' -f1 "$path/MyDBMS/$dbname/$tabel_name.metadata")
		# Prompt for input for each field
		columns=` cat "$path/MyDBMS/$dbname/$tabel_name.metadata" | wc -l `
		for (( i=1 ; i<=$columns ; i++));
		do
			echo -e "${LIGHTBLUE}Enter `sed -n "${i}p" "$path/MyDBMS/$dbname/$tabel_name.metadata" | cut -d":" -f1 `:  ${ENDCOLOR}" 
			read field_value 
			checktype

		#echo -n "$field_value:" >> "$tabel_name"  # Append each value on a new line
		done
		echo -e "${GREEN}------------------Recored inserted successfully--------------------------------${ENDCOLOR}"
	
	fi
done
echo -e "${BLUE}------------------Tables in schema $dbname are------------------------------${ENDCOLOR}"
ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
echo  -n "************to connect another schema, "
source ./connect_DB.sh