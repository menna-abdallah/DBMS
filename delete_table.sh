#! /usr/bin/bash

shopt -s extglob
LC_COLLATE=C

select del_choice in "Delete all Data" "Delete Rows" "Delete Colums" "EXIT"
do
	case $del_choice in
		"Delete all Data")
			t=$(awk 'NR==1 {print $0}' testtable)
			echo "$t"
			echo "$t" > newtable
			cat newtable

			;;
		"Delete Rows")
echo "mmm"
			;;
		"Delete Colums")
echo"mnnnn"
			;;
		"EXIT")
			exit
			;;
		*)
			echo "choose a suitable choice"
			;;
	esac
done

