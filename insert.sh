#! /bin/bash
function checktype{
'dataTypes=$(cut -d':' -f2 "$tabel_name.metadata")
for datatype in $dataTypes; do
	if [[ $datatype == "string"]]
	then 
	case $field in 
		+[A-Za-z][A-Za-z0-9])

done
}'
read -p "Enter name of tabel you want to insert in:  "  tabel_name
echo "tabels in your database are: `ls $(pwd)`"
if [ ! -e $(pwd)/$tabel_name ]
then 
echo "table not exist"
else 
typeset -i i=1
fields=$(cut -d':' -f1 "$tabel_name.metadata")
echo ${fields[@]}
#dataType=$(cut -d':' -f2 "$tabel_name.metadata")

# Prompt for input for each field

for field in $fields; do
    read -p "Enter $field: " field_value 
    echo -n "$field_value:" >> "$tabel_name"  # Append each value on a new line
done
echo " "
