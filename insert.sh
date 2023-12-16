#! /bin/bash
function PK() {
        ispk=`sed -n "${i}p" "$tabel_name.metadata" | cut -d":" -f3`

        if [[ $ispk == [Yy] ]]
        then
                check=`cut -d":" -f$i $tabel_name | awk -F: 'BEGIN{flag=0}{ if($i==$field_value){flag=1; break}} END{print $flag}'`
		return $check
fi
}
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
	#echo $check
	#start check
                if [[ $ispk == [Yy] ]]
                then
		check=`cut -d":" -f$i $tabel_name |  awk -F:  -v field_value="$field_value"  'BEGIN{flag=0}{ if( $i==field_value ){flag=1; exit}} END{print flag}' `
                fi
		# end check
		echo $check
		#start add
		if [[ $check == 3 || $check == 0 ]]
		then 
			#start check data type
			if [[ $dataType == "string" ]]
			then 
				#validate string
			if [[ $field_value =~ ^[a-zA-Z_][a-zA-Z0-9_" "]*$ ]] ;
			then
			append
			else
				echo "please enter string value"
			fi
		         # end validation
			else
				#validate int 
			if  [[ $field_value =~ ^[0-9]*$ ]]; 
	 		then
			append
               		else
                        echo "please enter int value"
	 		fi
                        # end validation
			fi
			# end check data type
		else 
			echo "value isn't unique"
		        exit	
		fi
}


echo "tabels in your database are:" `ls $(pwd) | grep -v '\.metadata$'`
read -p "select  name of tabel you want to insert in:  "  tabel_name
if [ ! -e $(pwd)/$tabel_name ]
then 
echo "table not exist"
else 
typeset -i i=1
fields=$(cut -d':' -f1 "$tabel_name.metadata")
# Prompt for input for each field
#typeset -i columns=0
columns=` cat "$tabel_name.metadata" | wc -l `
for (( i=1 ; i<=$columns ; i++));
do
    read -p "Enter `sed -n "${i}p" "$tabel_name.metadata" | cut -d":" -f1 `:  " field_value 
	checktype

    #echo -n "$field_value:" >> "$tabel_name"  # Append each value on a new line
done
fi
echo " "
