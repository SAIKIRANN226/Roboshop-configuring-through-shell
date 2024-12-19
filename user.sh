#!/bin/bash 

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DATE=$(date)
LOGFILE="/tmp/$0/$DATE.log"

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

VALIDATE $? "Installing nodeJS 18"

useradd roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop
else
    echo -e "User already exists so....$Y SKIPPING $N"
fi

mkdir -p /app &>> LOGFILE

VALIDATE $? "Creating app folder"

cd /app &>> LOGFILE

VALIDATE $? "Moving to the app folder"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> LOGFILE

VALIDATE $? "Downloading the application code"

unzip /tmp/user.zip &>> LOGFILE

VALIDATE $? "Unzipping the code"

npm install &>> LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/Roboshop-configuring-through-shell/user.service /etc/systemd/system/user.service &>> LOGFILE

VALIDATE $? "Copied user.service file"

systemctl daemon-reload &>> LOGFILE

VALIDATE $? "Loading the service"

systemctl enable user &>> LOGFILE

VALIDATE $? "Enabling the user"

systemctl start user &>> LOGFILE

VALIDATE $? "Starting the user"

cp /home/centos/Roboshop-configuring-through-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> LOGFILE

VALIDATE $? "Copied mongo.repo file"

dnf install mongodb-org-shell -y &>> LOGFILE

VALIDATE $? "Installing mongodb-org-shell"

mongo --host 172.31.89.135 </app/schema/user.js &>> LOGFILE

VALIDATE $? "Enabling remote connection"

systemctl restart user &>> LOGFILE

VALIDATE $? "Restated the user"