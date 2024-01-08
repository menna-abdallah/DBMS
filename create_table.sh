#! /bin/bash

shopt -s extglob
LC_COLLATE=C

path=`pwd`
export $dbname
function select_datatype(){
typeset -i flagtype=0;
while [ $flagtype -eq 0 ]
do
echo "select  Datatype of filed:" 
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
		echo "invalid data type, enter correct choice: "
		esac
done
done
}

function create_fields(){
	
read -p  "enter number of fields :  "  field_num
typeset -i i=1
while ! [[ $field_num =~ ^[0-9]+([.][0-9]+)?$ ]]
do
read -p  "please enter valid number:  "  field_num
done
while [ $i -le $field_num ]
do
	typeset -i flagf=1
	read -p  "enter name of field $i  :  "  field_name
	while [ $flagf -eq 1 ]
	do
		if [[ $field_name == "" ]]
		then
			read -p "field name can't be empty, please enter valid name :  " field_name

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
			read -p "this isn't valid name, please enter name again :  "  field_name
		fi
	done

	if [[ $answer == [Yy] ]]
	then
		select_datatype	
	else
		select_datatype
		read -p  "Is it primary key?(Y/N) :  "  answer
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

read -p  "enter number of tables :  "  table_num
typeset -i var=0
while ! [[ $table_num =~ ^[0-9]+([.][0-9]+)?$ ]]
do
read -p  "please enter valid number:  "  table_num
done
while [ $var -lt $table_num ]
do
	answer=""
	read -p  "enter name of table number of $(( $var + 1 )):  "  table_name
	typeset -i flag=1
	while [ $flag -eq 1 ]
	do
		if [[ $table_name == "" ]]
		then
			read -p "tabel name can't be empty , please enter valid name: " table_name
		elif [[ -e $table_name ]]
		then 
			read -p "table already exist, please enter name : " table_name
		elif [[ $table_name =~ ^[a-zA-Z_][a-zA-Z0-9_" "]*$ ]] ;
		then
			if [[ $table_name =~ [[:space:]] ]]
			then
				table_name=${table_name// /_}
				touch "$path"/MyDBMS/$table_name
				touch "$path/MyDBMS/$dbname/$table_name.metadata"
				create_fields
				echo "your table name is $table_name"
				echo "tabel created successfully" 
				flag=0
			else
				touch "$path/MyDBMS/$dbname/$table_name"
				touch "$path/MyDBMS/$dbname/$table_name.metadata"
				create_fields
				echo "-------------------------tabel created successfully----------------------------"
				flag=0
			fi		
		else
			read -p "this isn't valid name, please enter name again :  "  table_name
		fi
	done

	((var++))

done
				echo "####tabels in your database $dbname are : " 
				ls "$path/MyDBMS/$dbname" | grep -v '\.metadata$'
				echo  -n "to connect another schema, "
				source ./connect_DB.sh
#source ../../connect_DB.sh
