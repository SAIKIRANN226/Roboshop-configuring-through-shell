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
    echo -e "$Y Script starting executing at ${DATE} $N"
fi 

dnf install nginx -y

VALIDATE $? "Installing nginx"

systemctl enable nginx

VALIDATE $? "Enabling nginx"

systemctl start nginx

VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*

VALIDATE $? "Removing default content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

VALIDATE $? "Downloading the frontend content"

cd /usr/share/nginx/html

VALIDATE $? "Extracting the downloaded content"

unzip -o /tmp/web.zip

VALIDATE $? "Unzipping the code"

cp /home/centos/Roboshop-configuring-through-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf

VALIDATE $? "Copied roboshop.conf file"

systemctl restart nginx

VALIDATE $? 'restarted nginx"


