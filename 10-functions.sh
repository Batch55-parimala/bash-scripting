#!bin/bash

sample() {
    echo iam learning devops
    echo hai from hyderabad
}

sample

echo sample is completed for devops

sample

#There are 4 types of command available : 

# 1) Binary                   ( /bin  , /sbin )
# 2) Aliases                  ( Alises are shortcuts,  alias net="netstat -tulpn" )
# 3) Shell Built-in Commands  
# 4) Functions                # Functions are nothing but a set of command that can be written in a sequence and can be called n number of times as per your choice.



# How to declare a function ?

# This is how we can declare a function 
# f() {
#    echo hai
# }

# This is how we call a function
# f

stat () {
    echo "Numer of sessions opened are $(who | wc -l)"
    echo "Todays date is $(date +%F)"
    echo "average no of cpu utilization in last 5 min $(uptime | awk -F : '{print $NF}' | awk -F , '{print $2}')"
}

stat
