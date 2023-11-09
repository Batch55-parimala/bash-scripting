#!bin/bash

USER_ID=$(id -u)
COMPONENT=redis
LOGFILE="/tmp/${COMPONENT}.log"


if [ $USER_ID -ne 0 ] ; then
    echo -e "\e[31m script needs to executed by root user or sudo privilage \e[0m \n \t Example: \n\t\t sudo wrapper.sh frontend"
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
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo  &>>  ${LOGFILE}
stat $?

echo -n "Installing ${COMPONENT} :"
yum install redis-6.2.12 -y   &>>  ${LOGFILE}
stat $?

echo -n "Enabling  ${COMPONENT} visibility:"
sed -ie 's/127.0.0.1/0.0.0.0/g' /etc/${COMPONENT}.conf
sed -ie 's/127.0.0.1/0.0.0.0/g' /etc/${COMPONENT}/${COMPONENT}.conf
stat $?

echo -n "Starting  ${COMPONENT} service:"
systemctl daemon-reload   &>>  ${LOGFILE}
systemctl enable ${COMPONENT}    &>>  ${LOGFILE}
systemctl restart ${COMPONENT}     &>>  ${LOGFILE}
stat $?


echo -e "\e[35m Installation is completed \e[0m \n"