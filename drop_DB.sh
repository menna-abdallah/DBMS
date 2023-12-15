#!/usr/bin/bash

shopt -s extglob
export LC_COLLATE=C

# get the current path
path=`pwd`

declare -i db_no=`ls $path | wc -w`
select del_choice in "Delete all DataBases" "Delete a specific DataBase" "EXIT"
do
	case $del_choice in
		"Delete all DataBases")
			 echo "Worrinng You are going to delete all your DataBase"
                         read -p "press y to continue or n to quite: " confirm
		       	 if [ $confirm = 'y' -o $confirm = 'Y' ];
                         then
			 	if (( db_no == 0));
                        	then 
					echo " There is no DataBase yet!!"
                                else
					for _db in `ls $path`
					do
						rm -r $path/$_db
					done
					echo "All DataBase are deleted"
			 	fi
			else
				 exit
			 fi
			;;

		"Delete a specific DataBase")
			ls $(pwd)

			read -p "Enter the name of DataBase: " dbname

			#Check Exitance
       			 if [ ! -d "$path/$dbname" ];
       			 then
                		 echo " there is no DataBase with the name of $dbname"
       			 else
               			 echo "Worrinng You are going to delete $dbname"
            			 read -p "press y to continue or n to quite: " confirm
               			 if [ $confirm = 'y' -o $confirm = 'Y' ];
               			 then
                       			 rm -r $path/$dbname
					 echo "$dbname removed Successfully"
               			 else
                        		 exit
               			 fi
			 fi
			 ;;

		 "EXIT")
			 exit
			 ;;
			 *)
			 echo "Please, Enter a suitable choice"
	 esac
 done
