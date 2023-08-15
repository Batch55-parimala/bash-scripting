#!/bin/bash

echo "demo on if and of-else and else-if usage"

ACTION=$1

if [ "$ACTION" == "Start" ]; then
   echo -e "\e[32m starting payment service \e[0m"
   exit 0
fi
