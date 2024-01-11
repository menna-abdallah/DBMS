#!/bin/bash

shopt -s extglob
LC_COLLATE=C

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
LIGHTBLUE="\e[94m"
ENDCOLOR="\e[0m"

#TILL VALID NAME
while true
do
 echo -e "${LIGHTBLUE}Enter DataBase Name: ${ENDCOLOR}" 
 read DBNAME

#CHECK EXITANCE
if [ -z "$DBNAME" ];
then
	echo -e "${RED}DataBase name must not be empty${ENDCOLOR}"

elif [ -e "$(pwd)/MyDBMS/$DBNAME" ];
then
	echo -e "${YELLOW}$DBNAME is alredy exist${ENDCOLOR}"

# ... ${#DBNAME} = The length of BDNAME
elif [[ ${#DBNAME} -lt 1 || ${#DBNAME} -gt 64 ]];
then
      	echo -e "${RED}DataBase names must be in range of [1-64]${ENDCOLOR}"
elif [[ $DBNAME =~ ^[a-zA-Z_][a-zA-Z0-9_" "]*$ ]] ;
then
       	if [[ $DBNAME =~ [[:space:]] ]]
 then
	 echo -e "${YELLOW}DataBase Name is unvalid with spaces${ENDCOLOR}"
	 DBNAME=${DBNAME// /_}
	 echo -e "your DataBase name is ${BLUE} $DBNAME ${ENDCOLOR}"
	 mkdir "$(pwd)/MyDBMS"/$DBNAME
         echo -e "${GREEN}$DBNAME DataBase created successfully${ENDCOLOR}"
         break
else
	 mkdir "$(pwd)/MyDBMS"/$DBNAME
     echo -e "${GREEN}$DBNAME DataBase created successfully${ENDCOLOR}"
	 break
fi
else
	echo -e "${RED} $DBNAME is an Invalid Name ${ENDCOLOR}"
fi

done