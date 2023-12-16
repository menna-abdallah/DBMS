#! /bin/bash
read -p "Enter name of tabel you want to insert in:  "  tabel_name
typeset -i i=1
fields=$(cut -d':' -f1 "$tabel_name.metadata")
dataType=$(cut -d':' -f2 "$tabel_name.metadata")

# Prompt for input for each field

for ((i = 0; i < ${#fields[@]}; i++)); do
    read -p "Enter ${fields[i]} (${data_types[i]}): " field_value
    echo -n "$field_value:" >> "$tabel_name"  # Append each value on a new line
done
echo " "