#! /bin/bash
read -p "Enter name of table" table_name
select option in "select all" "select record" "select columns"
do 
	case $option in
		"select all")
			$(cat) $table_name
			;;
		"select record")
		`awk FS : '{print $0}'`	
