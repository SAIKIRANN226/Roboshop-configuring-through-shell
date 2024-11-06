#!/bin/bash

ID=$(id -u)
DATE=$(date)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE() {
    if [ $1 -ne 0 ]
    then 
        echo -e "$2....$R FAILED $N"
        exit 1
    else
        echo -e "$2....$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR:: Please run the script with root user $N"
    exit 1
else
    echo -e "$Y Script started executing at ${DATE} $N"
fi

dnf install mongodb-org -y 

VALIDATE $? "Installing mongodb"

systemctl enable mongod -y

VALIDATE $? "Enabling mongodb"

systemctl start mongod -y

VALIDATE $? "Starting mongodb"


