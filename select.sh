#! /bin/bash
shopt -s extglob 


typeset -i count=1
read -p "Enter name of table:   "  tabel_name
flag=1
nf="kkkk"
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
			echo "table fields are:"
			head -n 1 $tabel_name
			#read -p "write which field you want to build condition on:  " replay 	
			#read -p "Enter value you want to select:  " value 
			select opt in `awk -F':' '{ for (i=1; i<=NF; i++) print $i }' $tabel_name`
			do	
			select choice in "greater than"   "less than"   "greater than or equal"  "less than or equal"  "equal"
			do
				case $choice in 
					"greater than")
	# -v  used to assign a value to an awk variable from the shell.
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
    NR >= 2 && nf != -1 && $nf > value {
        print $0
    }
' "$tabel_name"

'awk -F: -v replay="$replay" -v value="$value" -v count="$count" 
    BEGIN { 
        nf = -1 
    }
    if (NR == 1) {
        for (i = 1; i <= NF; i++) {
            if ($i == replay) {
                nf = i
                break
            }
        }
    }
    if (NR >= 2 && nf != -1 && $nf > value) {
        print $0
    }
 "$tabel_name"
'
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
		read -p "Enter number of columns ypu want to retrieve" column_num

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
