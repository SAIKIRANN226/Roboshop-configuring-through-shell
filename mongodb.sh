#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DATE=$(date)

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
        echo -e "$2....$R FAILED $N"
        exit 1
    else    
        echo -e "$2....$G SUCCESS $N"
    fi 
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> tmp/saikiran.log

VALIDATE $? "Copied mongo.repo"

dnf install mongodb-org -y &>> tmp/saikiran.log

VALIDATE $? "Installing mongodb-org"

systemctl enable mongod &>> tmp/saikiran.log

VALIDATE $? "Enabling mongod"

systemctl start mongod &>> tmp/saikiran.log

VALIDATE $? "Starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> tmp/saikiran.log

VALIDATE $? "Giving remote access"

systemctl restart mongod &>> tmp/saikiran.log

VALIDATE $? "Restarting mongod"