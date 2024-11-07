#!/bin/bash

NUMBER=$1
R="\e[31m"
G="\e[32m"

if [ $NUMBER -lt 100 ]
then 
    echo -e "$R Given $NUMBER is less than 100"
else
    echo -e "$G Given number is not less than 100"
fi 


if [ $NUMBER -gt 100 ]
then 
    echo -e "$R Given number is greater than 100 $N"
else    
    echo -e "$Y Given number is not greater than 100 $N"
fi