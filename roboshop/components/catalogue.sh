#!bin/bash

USER_ID=$(id -u)
COMPONENT=catalogue
LOGFILE="/tmp/${COMPONENT}.log"
APPUSER="roboshop"


if [ $USERD_ID -ne 0 ] ; then
    echo -e "\e[31m script needs to executed by root user or sudo privilage \e[0m" \n \t Example: \n\t\t sudo wrapper.sh frontend
    exit 1

fi

stat() {

    if [ $1 -eq 0 ] ; then
       echo -e "\e[32m success \e[0m"
    else  
       echo -e "\e[31m failure \e[0m"
       exit 2
    fi
}   

echo -e "\e[35m configuring ${COMPONENT} \e[0m \n"

echo -n "Configuring ${COMPONENT} repo :"
curl --silent --location https://rpm.nodesource.com/setup_16.x |  bash -  &>>  ${LOGFILE}
stat $?

echo -n "Installing NodeJS :"
yum install nodejs -y   &>>  ${LOGFILE}
stat $?

id ${APPUSER}   &>>  ${LOGFILE}
if [ $? -ne 0 ] ; then 
   echo -n "Creating application User account:"
   useradd roboshop
   stat $?
fi
