   

LOGFILE="/tmp/${COMPONENT}.log"
APPUSER="roboshop"

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ] ; then
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

### Creating user account ##
CREATE_USER () {
    id ${APPUSER}   &>>  ${LOGFILE}
    if [ $? -ne 0 ] ; then 
        echo -n "Creating application User account:"
        useradd roboshop
        stat $?
    fi
}

DOWNLOAD_AND_EXTRACT() {

    echo -n "Downloading the ${COMPONENT}:"
    curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
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

## configuring services##
CONFIG_SVC() {
    echo -n "Updating the ${COMPONENT} service :"
    sed -ie 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/${APPUSER}/${COMPONENT}/systemd.service
    mv /home/${APPUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
    stat $?

   echo -n "Starting the  ${COMPONENT} service:"
   systemctl daemon-reload   &>>  ${LOGFILE}
   systemctl enable ${COMPONENT}   &>>  ${LOGFILE}
   systemctl restart ${COMPONENT}   &>>  ${LOGFILE}
   stat $?
}


## Declaring NodeJS ###
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

}
