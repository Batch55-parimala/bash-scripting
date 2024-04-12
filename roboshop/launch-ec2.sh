#!/bin/bash

#To create a server, what all information is needed?
# 1) AMI ID
# 2) Type of instance
# 3) security group ID
# 4) Instance you needed
# 5) DNS record: Hosted zone ID

COMPONENT=$1
HOSTEDZONE_ID="Z02308013R19EM36500WS"
INSTANCE_TYPE="t3.micro"

if  [ -z $1 ] ; then
     echo -e "\e[31m COMPONENT NAME IS NEEDED \e[0m \n \t \t"
     echo -e "\e[35m Ex Usage \e[0m \n\t\t $ bash launch-ec2.sh shipping"
     exit1
fi
     
AMI_ID="$(aws ec2 describe-images --filters "Name=name,Values= DevOps-LabImage-CentOS7" | jq ".Images[].ImageId" | sed -e 's/"//g')"
SG_ID="$(aws ec2 describe-security-groups --filters Name=group-name,Values=B55_Allow all | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')"

create_ec2() {

   echo -e "*****Creating \e[35m ${COMPONENT} \e[0m server is in progress ******"
   PRIVATEIP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.micro  --security-group-ids ${SG_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
   echo -e "Private IP addrees of the $COMPONENT is $PRIVATEIP \n\n"
   echo -e "Creating DNS record of ${COMPONENT}: "


   sed -e "s/$COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${PRIVATEIP}/" route53.json  >/tmp/r53.json
   aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONE_ID --change-batch file:///tmp/r53.json
   echo -e "Creating DNS record for $COMPONENT has completed \n\n"

}

if [ "$1" == "all" ]; then

    for component in mongodb payment cart redis rabbitmq user frontend shipping catalogue mysql; do
        COMPONENT=$component
        create_ec2
    done

else    
   
     create_ec2

fi       





