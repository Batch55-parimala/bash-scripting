#!/bin/bash

echo "demo on if and of-else and else-if usage"

ACTION=$1

if [ "$ACTION" == "Start" ]; then
   echo -e "starting payment"
   exit 0
fi
