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

dnf install nginx -y &>> LOGFILE

VALIDATE $? "Installing nginx"

systemctl enable nginx &>> LOGFILE

VALIDATE $? "Enabling nginx"

systemctl start nginx &>> LOGFILE

VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>> LOGFILE

VALIDATE $? "Removing the default content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> LOGFILE

VALIDATE $? "Downloading the roboshop content"

cd /usr/share/nginx/html &>> LOGFILE

VALIDATE $? "Extracting the content"

unzip /tmp/web.zip &>> LOGFILE

VALIDATE $? "Unzipping the code"

systemctl restart nginx &>> LOGFILE

VALIDATE $? "Restarting the nginx"

