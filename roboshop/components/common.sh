   

LOGFILE="/tmp/${COMPONENT}.log"
APPUSER="roboshop"

USER_ID=$(id -u)

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

CREATE_USER() {
    id ${APPUSER}   &>>  ${LOGFILE}
    if [ $? -ne 0 ] ; then 
        echo -n "Creating application User account:"
        useradd roboshop
        stat $?
    fi
}

DOWNLOAD_AND_EXTRACT() {

    echo -n "Downloading the ${COMPONENT}:"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
    stat $?

    cd /home/${APPUSER}/
    rm -rf ${COMPONENT}   &>>  ${LOGFILE}
    unzip -o /tmp/${COMPONENT}.zip  &>>  ${LOGFILE}
    stat $?

    echo -n "changing the ownership:"
    mv ${COMPONENT}-main ${COMPONENT}
    chown -R ${APPUSER}:${APPUSER} /home/${APPUSER}/${COMPONENT}
    stat $?
}


CONFIG_SVC() {
     echo -n "Configuring the ${COMPONENT} system file :"
        sed -i -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/'  -e 's/CARTHOST/cart.roboshop.internal/'  -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/'  -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/'  -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/${APPUSER}/${COMPONENT}/systemd.service
        stat $? 

   echo -n "Starting the  ${COMPONENT} service:"
   systemctl daemon-reload   &>>  ${LOGFILE}
   systemctl enable ${COMPONENT}   &>>  ${LOGFILE}
   systemctl restart ${COMPONENT}   &>>  ${LOGFILE}
   stat $?
}



NODEJS() {

    echo -e "\e[35m configuring ${COMPONENT} \e[0m \n"

    echo -n "Configuring ${COMPONENT} repo :"
    curl --silent --location https://rpm.nodesource.com/setup_16.x |  bash -  &>>  ${LOGFILE}
    stat $?

    echo -n "Installing NodeJS :"
    yum install nodejs -y   &>>  ${LOGFILE}
    stat $?
    CREATE_USER
    DOWNLOAD_AND_EXTRACT

    echo -n "Generating the ${COMPONENT} articrafts:"
    cd /home/${APPUSER}/${COMPONENT}/
    npm install  &>>  ${LOGFILE}
    stat $?

    CONFIG_SVC

}

MVN_PACKAGE() {
        echo -n "Generating the ${COMPONENT} artifacts :"
        cd /home/${APPUSER}/${COMPONENT}/
        mvn clean package   &>> ${LOGFILE}
        mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar
        stat $?
}

JAVA() {
        echo -e "\e[35m Configuring ${COMPONENT} ......! \e[0m \n"

        echo -n "Installing maven:"
        yum install maven -y    &>> ${LOGFILE}
        stat $? 

        CREATE_USER              # calls CREATE_USER function that creates user account.

        DOWNLOAD_AND_EXTRACT     # Downloads and extracts the components

        MVN_PACKAGE

        CONFIG_SVC

}


PYTHON() {
        echo -e "\e[35m Configuring ${COMPONENT} ......! \e[0m \n"

        echo -n "Installing python:"
        yum install python36 gcc python3-devel -y &>> ${LOGFILE}
        stat $? 

        CREATE_USER              # calls CREATE_USER function that creates user account.

        DOWNLOAD_AND_EXTRACT     # Downloads and extracts the components

        echo -n "Generating the artifacts"
        cd /home/${APPUSER}/${COMPONENT}/ 
        pip3 install -r requirements.txt    &>> ${LOGFILE} 
        stat $?

        USERID=$(id -u roboshop)
        GROUPID=$(id -g roboshop)

        echo -n "Updating the uid and gid in the ${COMPONENT}.ini file"
        sed -i -e "/^uid/ c uid=${USERID}" -e "/^gid/ c gid=${GROUPID}" /home/${APPUSER}/${COMPONENT}/${COMPONENT}.ini
        stat $?

        CONFIG_SVC
}