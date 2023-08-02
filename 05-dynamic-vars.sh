#!bin/bash

Date="$(date +%F)"
SESSIONS_COUNT=$(who |wc -l)

echo -e "Todays date is \e[33m $Date \e[0m"
echo -e "Total number of active sessions \e[34m $SESSIONS_COUNT \e[0m"


