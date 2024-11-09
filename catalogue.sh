#!/bin/bash

ID=$(id -u)
DATE=$(date)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

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


dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling old nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling nodejs:18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing nodejs"

id roboshop 
if [ $? -ne 0 ]
then 
    useradd roboshop
else
    echo -e "$Y User already exists so SKIPPING $N"
fi 

mkdir -p /app

VALIDATE $? "Creating app folder"

cd /app

VALIDATE $? "Moving to the app folder"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "Downloading the content in to the app folder"

unzip -o /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "Unzipping the code in to the app folder"

npm install &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/Roboshop-configuring-through-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "Copied the catalogue service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Daemon reloading is done"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enabling catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Starting catalogue"

cp /home/centos/Roboshop-configuring-through-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied mongo.repo file"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing mongodb-org shell"

mongo --host 172.31.42.202 </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Load schema"

systemctl restart catalogue &>> $LOGFILE

VALIDATE $? "Restarting the catalogue"

