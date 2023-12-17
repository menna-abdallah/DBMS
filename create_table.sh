#! /bin/bash

shopt -s extglob
LC_COLLATE=C

function select_datatype(){

echo "select  Datatype of filed:" 
select option in int  string
do
        case $option in
        int)
                field_type="int"
                ;;
        string)
                field_type="string"
                ;;
        *)
                echo "invalid data type"
esac
break
done
}
function create_fields(){
	
read -p  "enter number of fields :  "  field_num
typeset -i i=1
while [ $i -le $field_num ]
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
is_pK_define=$(awk -F: '$3 == "Y" || $3 == "y" {print 1}' "$table_name.metadata")
#is_pK_define=`awk -F: '{ if ( $3 == "Y" || $3 == "y"` ) {print 1} }' "$table_name.metadata"
if [ $(wc -l < "$table_name.metadata") -eq 0 -a ! $is_pk_define -eq 1 ]
then
echo $field_type":"$answer >> "$table_name.metadata"
else
	echo $field_type":n"  >> "$table_name.metadata"
fi
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
		 echo "tabel created successfully" 
                 ls $(pwd) | grep -v '\.metadata$'
		 flag=0
 		else
		 touch $table_name
		 touch "$table_name.metadata"
	 	 create_fields
		 echo "tabel created successfully" 
		 ls $(pwd) | grep -v '\.metadata$' 
		 flag=0
		fi		
	else
	read -p "this isn't valid name, please enter name again :  "  table_name
	fi
	done
	((var++))
done
#source ../../connect_DB.sh
