#! /bin/bash

shopt -s extglob
export LC_COLLATE=C

function append() {
if (( $i == $columns ))
                        then
                                echo  "$field_value" >> "$tabel_name"
                        else
                                echo -n  "$field_value:" >> "$tabel_name"
                        fi
}

function checktype() {

	dataType=`sed -n "${i}p" "$tabel_name.metadata" | cut -d":" -f2`
	ispk=`sed -n "${i}p" "$tabel_name.metadata" | cut -d":" -f3`
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
                check=`cut -d":" -f$i $tabel_name |  awk -F:  -v field_value="$field_value"  'BEGIN{flag=0}{ if( $i==field_value ){flag=1; exit}} END{print flag}' `
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
				read -p "please enter string value :  " field_value
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
                        read -p  "please enter int value :  " field_value
	 		fi
                        # end validation
			fi
		done
			# end check data type
		else 
			read -p "value isn't unique, please enter uniq value : " field_value	
		fi
	done
}


echo "tabels in your database are:" `ls $(pwd) | grep -v '\.metadata$'`
read -p "select  name of tabel you want to insert in:  "  tabel_name
flag_tabel=0
while [ $flag_tabel = 0 ]
do
if [ ! -e $(pwd)/$tabel_name ]
then 
read -p  "table not exist, please enter name again :  " tabel_name
else 
	flag_tabel=1
typeset -i i=1
fields=$(cut -d':' -f1 "$tabel_name.metadata")
# Prompt for input for each field
columns=` cat "$tabel_name.metadata" | wc -l `
for (( i=1 ; i<=$columns ; i++));
do
    read -p "Enter `sed -n "${i}p" "$tabel_name.metadata" | cut -d":" -f1 `:  " field_value 
	checktype

    #echo -n "$field_value:" >> "$tabel_name"  # Append each value on a new line
done
echo "recored inserted successfully"
fi
done
