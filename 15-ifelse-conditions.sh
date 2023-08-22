#!/bin/bash

echo "demo on if and of-else and else-if usage"

ACTION=$1

if [ "$ACTION" == "Start" ]; then
     echo -e "\e[32m starting payment \e[0m"
     exit 0

elif [ "$ACTION" == "stop" ]; then
      echo -e "\e[31m stopping payment \e[0m"
      exit1

elif [ "$ACTION" == "restart" ]; then
      echo -e "\e[35m restarting payment \e[0m"
      exit2 

 else
      echo -e "\e[35m Valid options are start or stop or restart \e[0m"
      echo -e "\e[33m Example usage \e[0m : \n \t bash scriptname stop"
      exit 3          
fi
