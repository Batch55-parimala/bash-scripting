#!/bin/bash

USER_ID=$(id -u)
COMPONENT=frontend
LOGFILE="/tmp/${COMPONENT}.log"


if [ $USERD_ID -ne 0 ] ; then
    echo -e "\e[31m script needs to executed by root user or sudo privilage \e[0m" \n \t Example: \n\t\t sudo wrapper.sh frontend
    exit 1

fi

stat() {

    if [ $1 -eq 0 ] ; then
       echo -e "\e[32m success \e[0m"
    else  
       echo -e "\e[31m failure \e[0m"
    fi
}   

echo -e "\e[35m configuring ${COMPONENT} \e[0m \n"

echo -n "Installing ngnix :"
yum install nginx -y   &>>   ${LOGFILE}
stat $?

echo -n "starting ngnix:"
systemctl enable nginx  &>>   ${LOGFILE}
systemctl start nginx   &>>   ${LOGFILE}
stat $?

echo -n "Downloading ${COMPONENT} component"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n "clean up the ${COMPONENT}:"
cd /usr/share/nginx/html
rm -rf *      &>>   ${LOGFILE}
stat $?

echo -n "Extracting ${COMPONENT}:"
unzip /tmp/frontend.zip      &>>   ${LOGFILE}
stat $?

echo -n "sorting out ${COMPONENT}:"
mv frontend-main/* .   &>>   ${LOGFILE}
mv static/* .          &>>   ${LOGFILE}
rm -rf frontend-main README.md  &>>   ${LOGFILE}
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Restarting ${COMPONENT}:"
systemctl daemon-reload     &>>   ${LOGFILE}
systemctl restart nginx     &>>   ${LOGFILE}
stat $?
