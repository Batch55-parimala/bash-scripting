#!bin/bash

COMPONENT=mysql

source components/common.sh


echo -e "\e[35m configuring ${COMPONENT}......! \e[0m \n"

echo -n "Configuring ${COMPONENT} repo: "
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
stat $?

echo -n "Installing ${COMPONENT} :"
yum install mysql-community-server -y   &>>  ${LOGFILE}
stat $?

echo -n "Starting the  ${COMPONENT} service:"
systemctl enable mysqld  &>>  ${LOGFILE}
systemctl start mysqld   &>>  ${LOGFILE}
stat $?

echo -n " Extracting the default root password : "
DEFAULT_ROOT_PASSWORD=$(grep "temporary password" /var/log/mysqld.log | awk -F " " '{print $NF}'
stat $?


echo "show databases;" |mysql -uroot -pRoboShop@1    &>>  ${LOGFILE}
if [ $? -ne 0 ];then
echo -n "Performing default password reset of root account :"
echo "ALTER USER 'root'@localhost' INDENTIFIED by 'RoboShop@1'" | mysql -uroot -p$DEFAULT_ROOT_PASSWORD    &>>  ${LOGFILE}
stat $?
fi

echo "show plugins" | mysql -uroot -pRoboShop@1 | grep validate_password  &>>  ${LOGFILE}  
if [ $? -eq 0 ]; then
echo -n "uninstalling password-validate plugin"
echo " uninstall plugin validate_password " | mysql -uroot -pRoboShop@1    &>>  ${LOGFILE}
fi

echo -n "Downloading the ${COMPONENT} schema:"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Extracting ${COMPONENT} schema:"
cd /tmp
unzip -o ${COMPONENT}.zip  &>>  ${LOGFILE}
stat $?

echo -n "Injecting the schema:"
cd /tmp
mysql -u root -pRoboShop@1 <shipping.sql
stat $?
