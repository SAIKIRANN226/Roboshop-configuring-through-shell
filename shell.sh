#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR:: Please run the script with root user $N"
    exit 1
else
    echo -e "$G Now you are root user you can install anything $N"
fi


yum install mysql -y

if [ $? -ne 0 ]
then 
    echo -e "$R ERROR:: Installing mysql is failed $N"
    exit 1
else
    echo -e "$G Installing mysql success $N"
fi 