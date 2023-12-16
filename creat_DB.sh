#!/bin/bash

shopt -s extglob
LC_COLLATE=C

#TILL VALID NAME
while true
do
 read -p "Enter DataBase Name: " DBNAME

#CHECK EXITANCE
if [ -e "$DBNAME" ];
then
	echo "$DBNAME is alredy exist"

#start VALIDATION

elif [ -z "$DBNAME" ];
then
	echo " DataBase name must not be empty"

# ... ${#DBNAME} = The length of BDNAME
elif [[ ${#DBNAME} -lt 1 || ${#DBNAME} -gt 64 ]];
then
      	echo " DataBase names must be in range of [1-64]"
elif [[ $DBNAME =~ ^[a-zA-Z_][a-zA-Z0-9_" "]*$ ]] ;
then
       	if [[ $DBNAME =~ [[:space:]] ]]
 then
	 echo " DataBase Name is unvalid with spaces"
	 DBNAME=${DBNAME// /_}
	 echo "your DataBase name is $DBNAME"
	 mkdir $(pwd)/$DBNAME
         echo " $DBNAME DataBase created successfully"
         break
else
	 echo "Valid Name"
	 mkdir $(pwd)/$DBNAME
	 echo " $DBNAME DataBase created successfully"
	 break
fi
else
	echo "Invalid Name"
fi

done
