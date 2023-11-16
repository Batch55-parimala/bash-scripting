#!bin/bash

USER_ID=$(id -u)
COMPONENT=rabbitmq
LOGFILE="/tmp/${COMPONENT}.log"


source components/common.sh

echo -e "\e[35m configuring ${COMPONENT} \e[0m \n"

echo -n "Configuring ${COMPONENT} repo :"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh |  bash   &>>  ${LOGFILE}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh |  bash   &>>  ${LOGFILE}
stat $?

echo -n "Installing ${COMPONENT} :"
yum install rabbitmq-server -y   &>>  ${LOGFILE}
stat $?


echo -n "Starting  ${COMPONENT} service:"
systemctl enable rabbitmq    &>>  ${LOGFILE}
systemctl start rabbitmq     &>>  ${LOGFILE}
stat $?

echo -n "Creating ${COMPONENT} user account:"
rabbitmqctl add_user roboshop roboshop123

echo -n "Configuring the permissions:"
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

echo -e "\e[35m Installation completed ${COMPONENT} \e[0m \n"