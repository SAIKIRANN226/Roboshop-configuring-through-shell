#!/bin/bash

ID=$(id -u)
DATE=$(date)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2.....$R FAILED $N"
        exit 1
    else    
        echo -e "$2.....$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR:: Please run the script with root user $N"
    exit 1
else
    echo -e "$Y Script started executing at ${DATE} $N"
fi 

dnf module disable nodejs -y

VALIDATE $? "Disabling old nodejs"

dnf module enable nodejs:18 -y

VALIDATE $? "Enabling nodejs18"

dnf install nodejs -y

VALIDATE $? "Installing nodejs"

id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop
else
    echo -e "$Y roboshop user already exist so SKIPPING $N"
fi 

mkdir /app

VALIDATE $? "Creating app folder to dowload the code"

cd /app

VALIDATE $? "Moving into the app folder"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading the code"

unzip -o /tmp/catalogue.zip

VALIDATE $? "Unzipping the code"

npm install 

VALIDATE $? "Installing dependencies"

cp /home/centos/Roboshop-configuring-through-shell/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "Copied catalogue service file"

systemctl daemon-reload

VALIDATE $? "daemon-reload"

systemctl enable catalogue

VALIDATE $? "Enabling catalogue"

systemctl start catalogue

VALIDATE $? "Starting catalogue"

cp /home/centos/Roboshop-configuring-through-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "Installing mongodb client"

dnf install mongodb-org-shell -y

VALIDATE $? "Installing mongo org shell"

mongo --host 172.31.39.63 </app/schema/catalogue.js

VALIDATE $? "Loading schema"

systemctl restart catalogue

VALIDATE $? "Restarting the catalogue"