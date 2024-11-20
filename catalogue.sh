#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 
else
    echo "You are root user"
fi 

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling old node js"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabing nodejs 18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing nodejs" 

useradd roboshop &>> $LOGFILE

VALIDATE $? "Adding user" 

mkdir /app &>> $LOGFILE

VALIDATE $? "Creating app folder" 

cd /app &>> $LOGFILE

VALIDATE $? "Moving to the app folder"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "Downlading"

unzip /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "Unzipping the code"

npm install &>> $LOGFILE

VALIDATE $? "Installing dependencies"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Daemon reloaded"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enabling catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Starting catalogue"

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied mongo.repo file"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing mongo.repo file"

mongo --host 172.31.38.249 </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "loaded schema"

systemctl restart catalogue &>> $LOGFILE

VALIDATE $? "Restarted catalogue"