#! /usr/bin/bash

shopt -s extglob
LC_COLLATE=C

ls $(pwd) | grep -v '.metadata'
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
			                        echo "choose the condition colum:"
			                        select opt in `cut -d":" -f1 "$tname.metadata"`
			                        do
				                        field_no=$REPLY
				                        break
			                        done	
				                        read -p "Enter value you want to delete:  " value 
				                        if [[ $value =~ ^[0-9]*$ ]];
				                                then
				                                
				                                select choice in "greater than" "less than" "equal" "Exit"
						                do
				                                      
				                                        case $choice in 
					                                        "greater than")
						                                        awk -v value="$value" -v field_no="$field_no" -F: '
						                                        { 
							                                if ( $field_no <= value ) print $0 
						                                        }' "$tname" >> temp
						                                        mv temp $tname
						                                        
						                                ;;
					                                        "less than")
						                                        awk -v value="$value" -v field_no="$field_no" -F: '
						                                        { 
							                                if ( $field_no >= value ) print $0 
						                                        }' "$tname" >> temp
						                                        mv temp $tname
						                                        
						                                ;;

					                                        "equal")
						                                        awk -v value="$value" -v field_no="$field_no" -F: '
						                                        { 
					                                                if ( $field_no != value ) print $0 
						                                        }' "$tname" >> temp
						                                        mv temp $tname
						                                        
						                                ;;
						                                "Exit")
						                                	exit
						                                ;;
						                                *)
						                                echo "not valid"
						                                ;;
			                                                esac	
			                                        done
			                                else
			                                awk -v value="$value" -v field_no="$field_no" -F: '
						                        { 
							                        if ($field_no != value) {print $0} 
						                        }' "$tname" >> temp
						                        mv temp $tname
						                  
			                                fi
		                        ;;
	                                "Delete Colums")
		                                echo "choose the condition colum:"
			                        select opt in `cut -d":" -f1 "$tname.metadata"`
			                        do
				                        field_no=$REPLY
				                        break
			                        done
			                        
			                        PK=$(awk -F: -v field_no="$field_no" '{if ( NR == field_no) {print $3}}' "$tname.metadata")
			                       
			                       if [[ $PK == "y"  || $PK == "Y" ]];
			                       then
			                          echo " you can not delete a primary key"
			                       else			                        
				                cut -d: -f"$field_no" --complement "$tname" >> temp
						mv temp $tname
					        fi
	                                ;;	
	                                "EXIT")
	                                        exit
	                                ;;
	                                *)
		                                echo "invalid choice"
		                        ;;
                                esac
                        done
        fi
