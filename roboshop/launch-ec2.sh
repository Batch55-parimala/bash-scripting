#!/bin/bash

#To create a server, what all information is needed?
# 1) AMI ID
# 2) Type of instance
# 3) security group ID
# 4) Instance you needed
# 5) DNS record: Hosted zone ID

COMPONENT=$1
if  [ -z $1 ] ; then
     echo -e "\e[31m COMPONENT NAME IS NEEDED \e[0m \n \t \t"
     echo -e "\e[35m Ex Usage \e[0m \n\t\t $ bash launch-ec2.sh shipping"
     exit1
fi
     
AMI_ID="ami-0f75a13ad2e340a58"
INSTANCE_TYPE="t3.micro"
SG_ID="sg-0cc65d7ddd0b64dad"


PRIVATEIP=$(aws ec2 run-instances --image-id "ami-0f75a13ad2e340a58" --instance-type t3.micro  --security-group-ids sg-0cc65d7ddd0b64dad --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" | jq '.Instances[].PrivateIpAddress') | sed -e 's/"//g'

echo "Private IP addrees of the $COMPONENT is $PRIVATEIP"

