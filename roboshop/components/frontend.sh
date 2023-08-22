#!bin/bash

USER_ID=$(id -u)

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

echo -e "\e[35m configuring frontend \e[0m \n"

echo -n "Installing ngnix :"
yum install nginx -y   &>>   /tmp/frontend.log
stat $?

echo -n "starting ngnix:"
systemctl enable nginx  &>>   /tmp/frontend.log
systemctl start nginx   &>>   /tmp/frontend.log
stat $?

echo -n "Downloading frontend component"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?






# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf
