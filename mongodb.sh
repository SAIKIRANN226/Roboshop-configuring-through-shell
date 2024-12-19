#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DATE=$(date)
LOGFILE="/tmp/$0/$DATE.log"

if [ $1 -ne 0 ]
then 
    echo -e "$2.....$R FAILED $N"
    exit 1
else
    echo -e "$2.....$G SUCCESS $N"
fi 

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR:: Please run the script with root user $N"
    exit 1
else
    echo -e "$Y Script started executing at $DATE $N "
fi 

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE

VALIDATE $? "Copied mongo.repo file"

dnf install mongodb-org -y &>> LOGFILE

VALIDATE $? "Installing mongodb"

systemctl enable mongod &>> LOGFILE

VALIDATE $? "Enabling mongodb"

systemctl start mongod &>> LOGFILE

VALIDATE $? "Starting mongod"

sed -i '127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> LOGFILE

VALIDATE $? "Enabling remote connections"

systemctl restart mongod &>> LOGFILE

VALIDATE $? "Restarting mongodb"