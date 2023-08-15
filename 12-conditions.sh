#!bin/bash

# Conditions helps us to execute something opnly if some factors is true and if that factor is false it will nolt execute.

# Syntax of CASE
# case $var in
#   opt1) command-x ;;
#   opt2) command-y ;;
# esac
  
Action=$1

case $Action in
   strat)
       echo -e "\e[32m starting payment service \e{0m"
       exit 0
       ;;
   stop)
       echo -e "\e[31 m stopping the payment service \e[0m"
       exit 1
       ;;
   restart)
       echo -e "\e[33m Restarting the payment serice \e[0m"
       exit 2
       ;;
    *)
       echo -e "\e[35m Valid options are strt or srestart \e[0m"
       echo -e "\e[33m Example usage \e[0m : /n /t bash scriptname stop"
       exit 3
       ;;
esac       