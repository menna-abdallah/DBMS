#! /usr/bin/bash

shopt -s extglob
LC_COLLATE=C

ls $(pwd) | grep -v '.metadata'

read -p " Enter the name of table you want to update: " tname

#CHECK EXITANCE
if [ ! -f "$tname" ];
	then
		echo " There is no table with that name"
	else
		
		echo "choose the condition colum:"
			select opt in $(cut -d":" -f1 "$tname.metadata")
				do
				 	field_no=$REPLY
				        break
			       	done	
		
		read -p " Enter the value you want to update: " value
		echo $value
		
		if ! grep -q "^$value:" "$tname" ; then
    			echo "there is no such value"
    		else
		
			read -p "Enter new value: " valu2
		fi
		
			col_DataType=$(awk -F: -v field_no="$field_no" '{if ( NR == field_no) {print $2}}' "$tname.metadata")
			PK=$(awk -F: -v field_no="$field_no" '{if ( NR == field_no) {print $3}}' "$tname.metadata")
			oldValue=$value
			colsNum=$(cat "$tname.metadata" |wc -l)
		
		if  [[ $value2 != "" ]];
		then
			intTest=1
			pkTest=1
			strtTest=1
		fi
		
		if [[ $col_DataType == "int"  && $value =~ ^[0-9]*$ ]];
		then
      			intTest=1
      			echo "$intTest"
      		else
        		echo  "this is not an integer value"
        		intTest=0
      		fi
      		
      	if [[ $PK =~ [yY] ]]; then
    	if awk -v col="$field_no" -F: '{print $col}' "$tname" | grep -q "^$value2$"; then
     	   echo "This value isn't unique"
     	   pkTest=0
   	 else
   	     pkTest=1
    	fi
	fi

        	
        	if (( $intTest*$pkTest == 1));
		then
			echo "valid value"
		awk -F: '
		{for(i=1;i <= NF; i++)
		{if($i~"$oldvalue"){$i="$value"; print $0}}
		}' $tname > temptable
		mv temptable $tname
		echo "Updated SUccessfully"
		cat $tname
		else
			echo "invalid"
		fi	
	
	fi	
		
		
