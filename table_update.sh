#! /usr/bin/bash

shopt -s extglob
LC_COLLATE=C

ls $(pwd) | grep -v '\.metadata'

read -p " Enter the name of table you want to update: " tname

#CHECK EXITANCE
if [ ! -f "$tname" ];
	then
		echo " There is no table with that name"
	else
		echo which column will you update upon
		cat $tname.metadata | cut -f1 -d:
		read col
		# echo "$col"
		
		declare -i colNum=$(awk 'BEGIN{FS=":"}{if($1=="$col") {print NR}}' $tname.metadata)
		
		read " Enter the value you want to update: " value
		var=$(awk 'BEGIN{FS=":"}{print $(("$col"))}' $tname)
		
		echo "$var"
		
		####///////////// 
		if ! [[ $value =~ ^[`awk 'BEGIN{flag=0}
		   {print $(("$col"))}' $tname`] ]]; 
		then
		echo "there is no such value"
		return
		fi
		
		oldValue=$value
		colsNum=$(cat .$tname.metadata |wc -l)
		read "Enter new value: " valu2
		
		for ((col=1;col<=$colsNum;col++));
		do
		# colName=$(awk 'BEGIN{FS=":"}{if(NR=='$col') print $1}' $tname.metadata)
		colType=$(awk 'BEGIN{FS=":"}{if(NR=='$col') print $2}' $tname.metaata)
		PK=$(awk 'BEGIN{FS=":"}{if(NR=='$col') print $3}' $tname.metadata)
		
		if  [[ $value2 != "" ]];
		then
			intTest=1
			pkTest=1
			strtTest =1
		if [[ $colType == "int" ]];
		then
		if ! [[ $value2 =~ ^[0-9]*$ ]]; 
		then
        		echo  "this is not an integer value"
        		intTest=0
      		else
      			intTest=1
      		fi
		else 
			intTest=1
		fi
		if [ "$colType" -eq "string" ];
		then
		if ! [[ $value =~ ^[a-zA-Z]*$ ]]; 
		then
        		echo  "this is not an integer value"
        		strTest=0
      		else
      			strTest=1
      		fi
		else 
			strTest=1
		fi
		fi
		
		#check for primary
		
		if [[ $PK == "y" ]];
		then
			if  [[ $value =~ ^[`awk 'BEGIN{FS=":"}{print $(("$col"))}' $tname.table`] ]]; 
		then
        	echo "This value isn't unique"
        		pkTest=0
        	else
       			 pkTest=1
        	fi
		else
        		pkTest=1
		fi
		
		
		if (( $intTest*$pkTest == 1));
		then
			echo "valid value"
		else
			echo "invalid"
		fi
		awk -F: '
		{for(i=1;i<NF;i++)
		{if($i~"$oldvalue"){$i="$value"; print $0}}
		}' $tname.table > temptable
		mv temptable $tname.table
		
	fi
		
		
		
		
