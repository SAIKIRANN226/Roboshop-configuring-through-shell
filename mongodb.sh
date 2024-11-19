#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $1 -ne 0 ]
then 
    echo -e "$2.....$R FAILED $N"
    exit 1
else
    echo -e "$2.....$G SUCCESS $N"
fi 

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR: Please run the script with root user $N"
    exit 1
else    
    echo -e "$Y Root user $N"
fi 

cp mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copied mongo repo 


