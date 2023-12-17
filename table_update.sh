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
		if [  `grep -F "$value" "$tname" | wc -w` -eq 0 ]; then
    			echo "there is no such value"
    		else
		
			read -p "Enter new value: " value2
		fi
			col_DataType=$(awk -F: -v field_no="$field_no" '{if ( NR == field_no) {print $2}}' "$tname.metadata")
			PK=$(awk -F: -v field_no="$field_no" '{if ( NR == field_no) {print $3}}' "$tname.metadata")
			oldValue=$value
			colsNum=$(cat "$tname.metadata" |wc -l)
		if  [[ $value2 != "" ]];
		then
			echo "allowed" 
			intTest=1
			pkTest=1
			strtTest=1
		else
			echo "not allowed"
		fi
		
		if [[ $col_DataType == "int" ]]
		then       
			if [[ $value2 =~ ^[0-9]*$ ]];
			then
      				intTest=1
      				echo "$intTest"
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
      		
      	if [[ $PK =~ [yY] ]]; then
    	if awk -v col="$field_no" -F: '{print $col}' "$tname" | grep -q "^$value2$"; then
     	   echo "This value isn't unique"
     	   pkTest=0
   	 else
   	     pkTest=1
    	fi
	fi

        	
        	if (( (intTest * pkTest == 1) || (strTest * pkTest == 1) ));
		then
			echo "valid value"
		awk -F: -v oldvalue="$oldValue" -v value2="$value2" '
			{for (i = 1; i <= NF; i++) {
          		if ($i == oldvalue) {
              		$i = value2;}
       		   }
	                           print $0;

      		}' "$tname" > temptable
    		mv temptable "$tname"
    		echo "Updated Successfully"
    		cat "$tname"
		else
			echo "invalid"
		fi	
	
	fi	
		
		
