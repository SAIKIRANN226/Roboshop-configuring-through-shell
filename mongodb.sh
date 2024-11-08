#!/bin/bash

ID=$(id -u)
DATE=$(date)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0"

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2.....$R FAILED $N"
        exit 1
    else
        eecho -e "$2....$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR:: Please run the script with root user $N"
    exit 1
else
    echo -e "$Y Script started executing at ${DATE} $N"
fi

echo -e "$Y Script started executing at ${$DATE} $N"


dnf install mongodb-org -y 

VALIDATE $? "Installing mongodb"

systemctl enable mongod

VALIDATE $? "Enabling mongod"

systemctl start mongod

VALIDATE $? "Starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

VALIDATE $? "Giving remote access to the mongodb"



