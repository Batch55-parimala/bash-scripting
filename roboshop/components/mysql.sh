#!bin/bash

COMPONENT=mysql

source components/common.sh


echo -e "\e[35m configuring ${COMPONENT}......! \e[0m \n"

echo -n "\e[35m Configuring ${COMPONENT} repo \e[0m \n"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
stat $?

echo -n "Installing NodeJS :"
yum install mysql-community-server -y   &>>  ${LOGFILE}
stat $?
