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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y $>> $LOGFILE

VALIDATE $? "Installing repo file"

dnf module enable redis:remi-6.2 -y $>> $LOGFILE

VALIDATE $? "Enabling remi 6.2"

dnf install redis -y $>> $LOGFILE

VALIDATE $? "Installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf $>> $LOGFILE

VALIDATE $? "Giving remote access"

systemctl enable redis $>> $LOGFILE

VALIDATE $? "Enabling redis"

systemctl start redis $>> $LOGFILE

VALIDATE $? "Starting redis"