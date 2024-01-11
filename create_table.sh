#! /bin/bash

shopt -s extglob
LC_COLLATE=C

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
LIGHTBLUE="\e[94m"
ENDCOLOR="\e[0m"

path=`pwd`
export $dbname
function select_datatype(){
typeset -i flagtype=0;
while [ $flagtype -eq 0 ]
do
echo -e "${LIGHTBLUE}select  Datatype of filed: ${ENDCOLOR}" 
select option in int  string
do
	case $option in
	int)
		flagtype=1;
		field_type="int"
		break
		;;
	string)
		flagtype=1;
		field_type="string"
		break
		;;
	*)
		echo -e "${BLUE}invalid data type, enter correct choice: ${ENDCOLOR}"
		esac
done
done
}

function create_fields(){
	
echo -e "${LIGHTBLUE}Enter number of fields :  ${ENDCOLOR}"  
read field_num
typeset -i i=1
while ! [[ $field_num =~ ^[0-9]+([.][0-9]+)?$ ]]
do
echo -e "${BLUE}Invalid value, enter valid number:  ${ENDCOLOR}"  
read field_num
done
while [ $i -le $field_num ]
do
	typeset -i flagf=1
	echo -e "${LIGHTBLUE}Enter name of field $i  :  ${ENDCOLOR}"  
	read field_name
	while [ $flagf -eq 1 ]
	do
		if [[ $field_name == "" ]]
		then
			echo -e "${RED}field name can't be empty${ENDCOLOR}"
			echo -e "${BLUE}Invalid value , enter valid name :  ${ENDCOLOR}" 
			read field_name

		elif [[ $field_name =~ ^[a-zA-Z_][a-zA-Z0-9_" "]*$ ]] ;
		then
			if [[ $field_name =~ [[:space:]] ]]
			then
				field_name=${field_name// /_}
				echo -n $field_name":" >> "$path/MyDBMS/$dbname/$table_name.metadata"
				flagf=0
			else
				echo -n $field_name":" >> "$path/MyDBMS/$dbname/$table_name.metadata"
			flagf=0
			fi
		else
			echo -e "${RED}This isn't valid name ${ENDCOLOR}"
			echo -e "${BLUE}Enter name again :  ${ENDCOLOR}"  
			read field_name
		fi
	done

	if [[ $answer == [Yy] ]]
	then
		select_datatype	
	else
		select_datatype
		echo -e "${LIGHTBLUE}Is it primary key?(Y/N) :  ${ENDCOLOR}"  
		read answer
	fi
	export ${field_name}
	export ${field_type}
	export ${answer}

	is_pk_define=$(awk -F: '$3 == "Y" || $3 == "y" {print 1}' "$path/MyDBMS/$dbname/$table_name.metadata")
	#is_pK_define=`awk -F: '{ if ( $3 == "Y" || $3 == "y"` ) {print 1} }' "$table_name.metadata"

	if [[ $(wc -l < "$path/MyDBMS/$dbname/$table_name.metadata") -eq 0  ||  $is_pk_define -ne 1 ]]
	then
		echo $field_type":"$answer >> "$path/MyDBMS/$dbname/$table_name.metadata"
	else
		echo $field_type":n"  >> "$path/MyDBMS/$dbname/$table_name.metadata"
	fi

	((i++))
done

}

echo -e "${LIGHTBLUE}Enter number of tables :  ${ENDCOLOR}"  
read table_num
typeset -i var=0
while ! [[ $table_num =~ ^[0-9]+([.][0-9]+)?$ ]]
do
echo -e "${BLUE}Please enter valid number:  ${ENDCOLOR}"  
read table_num
done
while [ $var -lt $table_num ]
do
	answer=""
	echo -e "${LIGHTBLUE}Enter name of table $(( $var + 1 )):  ${ENDCOLOR}"  
	read table_name
	typeset -i flag=1
	while [ $flag -eq 1 ]
	do
		if [[ $table_name == "" ]]
		then
		echo -e "${RED}Tabel name can't be empty${ENDCOLOR}"
			echo -e "${BLUE}Please enter valid name: ${ENDCOLOR}" 
			read table_name
		elif [[ -e $table_name ]]
		then 
			echo -e "${YELLOW}Table already exist${ENDCOLOR}"
			echo -e "${BLUE}Please enter name : ${ENDCOLOR}" 
			read table_name
		elif [[ $table_name =~ ^[a-zA-Z_][a-zA-Z0-9_" "]*$ ]] ;
		then
			if [[ $table_name =~ [[:space:]] ]]
			then
				table_name=${table_name// /_}
				touch "$path"/MyDBMS/$table_name
				touch "$path/MyDBMS/$dbname/$table_name.metadata"
				create_fields
				echo -e "${GREEN}your table name is ${BLUE}$table_name${ENDCOLOR}"
				echo -e "${GREEN}tabel created successfully${ENDCOLOR}" 
				flag=0
			else
				touch "$path/MyDBMS/$dbname/$table_name"
				touch "$path/MyDBMS/$dbname/$table_name.metadata"
				create_fields
				echo -e "${GREEN}-------------------------tabel created successfully----------------------------${ENDCOLOR}"
				flag=0
			fi		
		else
			echo -e "${RED}This isn't valid name${ENDCOLOR}"
			echo -e "${BLUE} enter name again :  ${ENDCOLOR}"  
			read table_name
		fi
	done

	((var++))

done
				echo -e "${BLUE}####Tabels in your database $dbname are : ${ENDCOLOR}" 
				ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
				echo  -n "*********to connect another schema"
				source ./connect_DB.sh
#source ../../connect_DB.sh
