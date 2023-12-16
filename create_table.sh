#! /bin/bash

shopt -s extglob
LC_COLLATE=C
function create_fields(){
	
read -p  "enter number of fields :  "  field_num
typeset -i i=0
while [ $i -lt $field_num ]
do
        typeset -i flagf=1
read -p  "enter name of field :  "  field_name
while [ $flagf -eq 1 ]
        do
        if [[ $field_name =~ ^[a-zA-Z_][a-zA-Z0-9_" "]*$ ]] ;
        then
                if [[ $field_name =~ [[:space:]] ]]
                then
                 field_name=${field_name// /_}
                 echo -n $field_name":" >> "$table_name.metadata"
                 flagf=0
                else
                 echo -n $field_name":" >> "$table_name.metadata"
                flagf=0
                fi
        else
        read -p "this isn't valid name, please enter name again :  "  field_name
        fi
done
read -p  "enter Datatype of filed :  "  field_type
read -p  "Is it primary key?(Y/N) :  "  answer
export ${field_name}
export ${field_type}
export ${answer}
echo $field_type":"$answer >> "$table_name.metadata"
((i++))
done
}

read -p  "enter number of tables :  "  table_num
typeset -i var=0
typeset -i flag=1
while [ $var -lt $table_num ]
do
	while [ $flag -eq 1 ]
	do
	read -p  "enter name of table :  "  table_name
	if [[ -e $table_name ]]
	then 
		echo "table already exist"
		flag=0
	elif [[ $table_name =~ ^[a-zA-Z_][a-zA-Z0-9_" "]*$ ]] ;
	then
       		if [[ $table_name =~ [[:space:]] ]]
	 	then
		 table_name=${table_name// /_}
		 touch $table_name
		 touch "$table_name.metadata"
                 create_fields
		 echo "your table name is $table_name"
		 flag=0
 		else
		 touch $table_name
		 touch "$table_name.metadata"
	 	 create_fields
		 flag=0
		fi		
	else
	read -p "this isn't valid name, please enter name again :  "  table_name
	fi
	done
	((var++))
done
