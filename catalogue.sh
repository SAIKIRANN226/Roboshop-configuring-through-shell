#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$Y $2.......$R FAILED $N"
        exit 1
    else
        echo -e "$Y $2.......$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR:: Please run the script with root user $N"
    exit 1
else
    echo -e "Root user"
fi

dnf module disable nodejs -y

VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:18 -y

VALIDATE $? "Enabling nodejs:18"

dnf install nodejs -y

VALIDATE $? "Installing nodejs"

id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "adding roboshop user"
else
    echo -e "already roboshop user exists so.....$Y SKIPPING"

mkdir -p /app

VALIDATE $? "Creating app folder"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading the code"

unzip /tmp/catalogue.zip

VALIDATE $? "Unzipping the code"

