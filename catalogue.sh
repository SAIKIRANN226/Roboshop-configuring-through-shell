#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR:: Please run the script with root user $N"
    exit 1
else
    echo -e "$Y Script started executing at $DATE $N"
fi

VALIDATE() {
if [ $1 -ne 0 ]
then 
    echo -e "$2.....$R FAILED $N"
    exit 1
else
    echo -e "$2.....$G SUCCESS $N"
fi 
}

dnf module disable nodejs -y &>> LOGFILE

VALIDATE $? "Disabling old nodeJS"

dnf module enable nodejs:18 -y &>> LOGFILE

VALIDATE $? "Enabling nodeJS 18"

dnf install nodejs -y &>> LOGFILE

VALIDATE $? "Installing nodeJS"

useradd roboshop &>> LOGFILE
if [ $? -ne 0 ]
then 
    useradd roboshop
else
    echo -e "roboshop user is already exists so.....$Y SKIPPING $N"
fi

mkdir -p /app &>> LOGFILE

VALIDATE $? "Creating app directory"

cd /app &>> LOGFILE

VALIDATE $? "Moving to the app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> LOGFILE

VALIDATE $? "Downloading the code in the app directory"

unzip -o /tmp/catalogue.zip &>> LOGFILE

VALIDATE $? "Unzipping the catalogue code"

npm install &>> LOGFILE

VALIDATE $? "Installing the dependencies"

cp /home/centos/Roboshop-configuring-through-shell/catalogue.service  /etc/systemd/system/catalogue.service &>> LOGFILE

VALIDATE $? "Copied catalogue.service to the location"

systemctl daemon-reload &>> LOGFILE

VALIDATE $? "Daemon reloaded"

systemctl enable catalogue &>> LOGFILE

VALIDATE $? "Enabling catalogue"

systemctl start catalogue &>> LOGFILE

VALIDATE $? "Starting catalogue"

cp /home/centos/Roboshop-configuring-through-shell/mongo.repo  /etc/yum.repos.d/mongo.repo &>> LOGFILE

VALIDATE $? "Copied mongo.repo to the given location"

dnf install mongodb-org-shell -y &>> LOGFILE

VALIDATE $? "Installing mongodb-org-shell"

mongo --host 172.31.89.135:27017 </app/schema/catalogue.js &>> LOGFILE

VALIDATE $? "Loading schema to the catalogue"

systemctl restart catalogue &>> LOGFILE

VALIDATE $? "Restarted catalogue"






