#!bin/bash

# Special variables gives s[ecial properties to your variables

# Here are the special variables : $0 to $9, $?, $#, $*, $@

# # ROCKET_NAME=Chandrayaan
a=10
b=20
c=30

echo value of a is $a
echo value of b is $b
echo value of c is $c

echo $0
echo "Executed script name is : $0"

echo "iam learning $1"
echo "we need to learn $2"
echo "its a 45days course to learn $3"

echo $$    # $$ is going to print the PID of the current proces 
echo $#    # $# is going to print the number of arguments
echo $?    # $? is going to print the exit code of the last command.
echo $*    # $* is going to print the used arguments
echo $@    # $* is going to print the used arguments