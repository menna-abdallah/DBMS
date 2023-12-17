#! /bin/bash

echo "tabels in your database are :"
ls $(pwd) | grep -v '\.metadata' 

read -p "Enter name of tabel:  " tabel_name
shopt -s extglob 
export LC_COLLATE=C

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
			select opt in `cut -d":" -f1 "$tabel_name.metadata"`
			do	
				read -p "Enter value you want to select:  " value 
			select choice in "greater than"   "less than"   "greater than or equal"  "less than or equal"  "equal"
			do
				case $choice in 
					"greater than")
	# -v  used to assign a value to an awk variable from the shell.

awk -v value="$value" -v field="$REPLY" -F: '
    NR == 1 {
        nf = 0
        for (i = 1; i <= NF; i++) {
            if ($i == field) {
                nf = i
                break
            }
        }
    }
    NR >= 2 && nf != 0 && $nf > value {
        print $0
    }
' "$tabel_name"
;;
					"less than")
						awk -F: -v replay="$replay" -v value="$value" -v count="$count" '
    BEGIN {
        nf = -1
    }
    NR == 1 {
        for (i = 1; i <= NF; i++) {
            if ($i == replay) {
                nf = i
                break
            }
        }
    }
    NR >= 2 && nf != -1 && $nf < value {
        print $0
    }
' "$tabel_name"


						;;
					"greater than or equal")
                                                awk -F: -v replay="$replay" -v value="$value" -v count="$count" '
    BEGIN {
        nf = -1
    }
    NR == 1 {
        for (i = 1; i <= NF; i++) {
            if ($i == replay) {
                nf = i
                break
            }
        }
    }
    NR >= 2 && nf != -1 && $nf >= value {
        print $0
    }
' "$tabel_name"


                                                ;;
                                        "less than or equal")
                                                awk -F: -v replay="$replay" -v value="$value" -v count="$count" '
    BEGIN {
        nf = -1
    }
    NR == 1 {
        for (i = 1; i <= NF; i++) {
            if ($i == replay) {
                nf = i
                break
            }
        }
    }
    NR >= 2 && nf != -1 && $nf <= value {
        print $0
    }
' "$tabel_name"


                                                ;;

					"equal")
						awk -F: -v replay="$replay" -v value="$value" -v count="$count" '
    BEGIN {
        nf = -1
    }
    NR == 1 {
        for (i = 1; i <= NF; i++) {
            if ($i == replay) {
                nf = i
                break
            }
        }
    }
    NR >= 2 && nf != -1 && $nf == value {
        print $0
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
		read -p "Enter number of columns you want to retrieve:  " column_num
		select opt in "select all values in columns" "select supecific values"
		do
			case $opt in 
				"select all values in columns")
					cut -d":" -f1 "$tabel_name.metadata" | nl -w1  
					read -p "please enter number of each column you want to retrieve it:  " column
					# Read the values from the column into an array
					read -r -a columns <<< "$column"
					for (( i=1 ; i<=${#columns[@]}; i++));
					do
						var=$(( ${columns[i]} + 1 ))
						cut -d":" -f$var $tabel_name < temp | cat 		
					done
						;;
			"select supecific values")
				;;
			*)
				echo "please select valid option"
		esac
	done
		;;
	*)
		echo "invalid choice"
		;;
esac
done
else 
	read -p "table not exist, please enter correct name: " tabel_name
fi
done

