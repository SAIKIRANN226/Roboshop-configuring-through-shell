#!/bin/bash

ID=$(id -u)
DATE=$(date)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGFILE="/tmp/$DATE.log"

VALIDATE() {
    if [ $1 -ne 0 ]
    then 
        echo -e "$Y $2.....$R FAILED $N"
        exit 1
    else
        echo -e "$Y $2.....$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR:: Please run the script with root user $N"
    exit 1
else
    echo -e "$Y This script started executing at ${DATE} $N"
fi


for package in $@
do 
    yum list installed $package
    if [ $? -ne 0 ]
    then 
        yum install $package -y $>> $LOGFILE
    else
        echo -e "$package is already installed so $Y.....SKIPPING $N"
    fi
done