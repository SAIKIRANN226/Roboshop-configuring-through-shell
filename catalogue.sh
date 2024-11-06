#!/bin/bash

ID=$(id -u)
DATE=$(date)

VALIDATE() {
    if [ $1 -ne 0 ]
    then 
        echo -e "$2....$R FAILED $N"
        exit 1
    else
        echo -e "$2....$G SUCCESS $N"
    fi
}

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $ID -ne 0 ]
then    
    echo -e "$R ERROR:: Please run this script with root user $N"
    exit 1
else
    echo -e "$Y Script started executing at ${DATE} $N"
fi


dnf module disable nodejs -y

VALIDATE $? "Disabling nodejs 10"

dnf module enable nodejs:18 -y

VALIDATE $? "Enabling nodejs 18"

dnf install nodejs -y

VALIDATE $? "Installing nodejs"

useradd roboshop

VALIDATE $? "Adding roboshop user"





