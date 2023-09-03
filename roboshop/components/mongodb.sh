#!bin/bash

SER_ID=$(id -u)
COMPONENT=mongodb
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

echo -n "Configuring ${COMPONENT} repo :"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n "Installing ${COMPONENT} :"
yum install -y mongodb-org    &>>  ${LOGFILE}
stat $?

echo -n "Enabling  ${COMPONENT} visibility:"
sed -ie 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
stat $?

echo -n "Starting  ${COMPONENT} service:"
systemctl enable mongod    &>>  ${LOGFILE}
systemctl start mongod     &>>  ${LOGFILE}