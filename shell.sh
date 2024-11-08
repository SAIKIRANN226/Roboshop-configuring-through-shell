#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DATE=$(date)

VALIDATE() {
    if [ $1 -ne 0 ]
    then    
        echo -e "$Y $2......$R FAILED $N"
        exit 1
    else    
        echo -e "$Y $2......$G SUCCESS $N"
    fi
}

for package in $@
do
    yum list installed $package
    if [ $? -ne 0 ]
    then    
        yum install $package -y
    else
        echo -e "$Y $package is already installed so $Y.......SKIPPING $N"
    fi
done