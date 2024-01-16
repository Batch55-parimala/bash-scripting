#!/bin/bash

#To create a server, what all information is needed?
# 1) AMI ID
# 2) Type of instance
# 3) security group ID
# 4) Instance you needed
# 5) DNS record: Hosted zone ID

AMI_ID="ami-0f75a13ad2e340a58"
INSTANCE_TYPE="t3.micro"
SG_ID="sg-0cc65d7ddd0b64dad"



aws ec2 run-instances --image-id ${AMI_ID} --count 1 --instance-type ${INSTANCE_TYPE}  --security-group-ids ${SG_ID} --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]


