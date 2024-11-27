#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
# LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" 

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

dnf install nginx -y 

VALIDATE $? "Installing nginx"

systemctl enable nginx

VALIDATE $? "Enabling nginx"

systemctl start nginx

VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* 

VALIDATE $? "Removed default content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip 

VALIDATE $? "Downloaded the content"

cd /usr/share/nginx/html 

VALIDATE $? "Extracted the content"

unzip /tmp/web.zip 

VALIDATE $? "Unzipped the content"

systemctl restart nginx 

VALIDATE $? "Restarted nginx"

