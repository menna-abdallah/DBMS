#! /usr/bin/bash

shopt -s extglob
LC_COLLATE=C

ls $(pwd) | grep -v '\.metadata'
read -p " Enter the name of table you want to delete its data: " tname

#CHECK EXITANCE
if [ ! -f "$tname" ];
	then
		echo " There is no table with that name"
	else
		select del_choice in "Delete all Data" "Delete Rows" "Delete Colums" "EXIT"
		do
			case $del_choice in
				
				"Delete all Data")
				echo "Worrinng You are going to delete $tname"
				read -p "press y to continue or n to quite: " confirm
               				if [ $confirm = 'y' -o $confirm = 'Y' ];
               				then
               					echo " " > $(pwd)/$tname
               					echo "Data Deleted Successfully"
               				else
               					exit
               				fi		
			;;
			"Delete Rows")
			while (true)
			do
				read -p "Which colum you want to delete according to: " col

				if grep -q "$col" "$(pwd)/$tname.metadata"; then
			#get colum number
			declare -i filed_no=$(awk -F: -v col="$col"'
			{if ($1 == col) print NR}' "$tname.metadata")
			echo "$field_no"
			read -p "Please enter the field  value : " field_v
			awk -F: -v field_v="$field_v" -v field_no="$field_no" '{if ($field_no != field_v) print $0}' > new_temp
			mv new_temp $tname
			echo " deleted successfully"
			cat $tname
			
					
			break	
				else
				echo " Wrong colum name"
			fi
			done
			;;
			"Delete Colums")
				read -p "Which colum you want to delete: " col

				if grep -q "$col" "$(pwd)/$tname.metadata"; then
			#get colum number
			declare -i filed_no=$(awk -F: -v col="$col"'
			{if ($1 == col) print NR}' "$tname.metadata")
			echo "$field_no"
			awk -F: '{print $3}' input_file > output_file

			awk -F: -v field_no="$field_no" '{
			i = 1
			while (i <=Nf ){
			if ($field_no != $i) print $i
			}
			}' > new_temp
			
			mv new_temp $tname
			cat $tname
			fi				
				
			;;
			"EXIT")
				exit
			;;
			*)
				echo "choose a suitable choice"
			;;
	esac
done
fi
