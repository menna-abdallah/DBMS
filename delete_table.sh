#! /usr/bin/bash

shopt -s extglob
LC_COLLATE=C

select del_choice in "Delete all Data" "Delete Rows" "Delete Colums" "EXIT"
do
	case del_choice in
		"Delete all Data")

			;;
		"Delete Rows")

			;;
		"Delete Colums")

			;;
		"Exit")
			exit
			;;
		*)
			echo "choose a suitable choice"
			;;
	esac
done

