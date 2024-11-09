#1/bin/bash

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
    echo -e "$Y Script started executing at ${DATE} $N"
fi 

dnf module disable nodejs -y 

VALIDATE $? "Disabling old nodejs"

dnf module enable nodejs:18 -y 

VALIDATE $? "Enabling nodejs:18"

dnf install nodejs -y 

VALIDATE $? "Installing nodejs"

id roboshop 
if [ $? -ne 0 ]
then 
    useradd roboshop
else
    echo -e "$Y User already exists so SKIPPING $N"
fi 

mkdir -p /app

VALIDATE $? "Creating app folder"

cd /app

VALIDATE $? "Moving to the app folder"

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

VALIDATE $? "Downloading the content in to the app folder"

unzip -o /tmp/user.zip

VALIDATE $? "Unzipping the code in to the app folder"

npm install

VALIDATE $? "Installing dependencies"

cp /home/centos/Roboshop-configuring-through-shell/user.service /etc/systemd/system/user.service

VALIDATE $? "Copied user.service file"

systemctl daemon-reload

VALIDATE $? "Loaded daemon"

systemctl enable user 

VALIDATE $? "Enabled user"

systemctl start user

VALIDATE $? "Started user"

cp /home/centos/Roboshop-configuring-through-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "Copied mongo.repo"

dnf install mongodb-org-shell -y

VALIDATE $? "Installing mongodb-org-shell"

mongo --host 172.31.42.202 </app/schema/user.js

systemctl restart user

VALIDATE $? "Restarted user"

