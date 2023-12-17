#! /bin/bash

shopt -s extglob 
export LC_COLLATE=C

echo "tabels in your database are :"
ls $(pwd) | grep -v '\.metadata'
read -p "Enter name of tabel:  " tabel_name

typeset -i count=1
flag=1
while [ $flag = 1 ]
do
   if [ -e $tabel_name ]
then
flag=0	

select option in "select all" "select record" "select columns"
do 
	case $option in
		"select all")
			cat $tabel_name
			;;
		"select record")
			echo "tabel fields are:"
			#cut -d":" -f1  "$tabel_name.metadata" | nl -w1
			echo "select one attribute to build your condition on:"

			select opt in `cut -d":" -f1 "$tabel_name.metadata"`
			do
				replay=$REPLY	
				read -p "Enter value you want to select:  " value 
			select choice in "greater than"   "less than"   "greater than or equal"  "less than or equal"  "equal"
			do
				case $choice in 
					"greater than")
					      # -v  used to assign a value to an awk variable from the shell.
						awk -v value="$value" -v field="$replay" -F: '
						{ 
							if ( $field > value ) { print $0 }
						}					

						' "$tabel_name"
						;;
					"less than")
						awk -v value="$value" -v field="$replay" -F: '
						{ 
        						if ( $field < value ) { print $0 }
        					}	

						' "$tabel_name"

						;;
					"greater than or equal")
                                                awk -v value="$value" -v field="$replay" -F: '
						{ 
        						if ( $field >= value ) { print $0 }
        					}

						' "$tabel_name"

                                                ;;
                                        "less than or equal")
                                                awk -v value="$value" -v field="$replay" -F: '
						{ 
        						if ( $field <= value ) { print $0 }
        					}

						' "$tabel_name"

                                                ;;

					"equal")
						awk -v value="$value" -v field="$replay" -F: '
						{ 
        						if ( $field == value ) { print $0 }
        					}

						' "$tabel_name"
						;;
						*)
						echo "invalid choice"
						;;
				esac
			done
		done
		;;
	"select columns")
					cut -d":" -f1 "$tabel_name.metadata" | nl -w1  
					read -p "please enter number of each column you want to retrieve it from those fields:  " columns
					awk -F: '{print $@}' $tabel_name
					for column in $columns; 
					do
					echo "Values in column Number $column are:"  
					cut -d":" -f$column   "$tabel_name" 
					#cat temp	
					#awk -F: '{ print $('$column') }' "$tabel_name"
					done
				#rm temp
				esac
done
else 
	read -p "table not exist, please enter correct name: " tabel_name
fi
done

