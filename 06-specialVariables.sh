#!bin/bash

# Special variables gives s[ecial properties to your variables

# Here are the special variables : $0 to $9, $?, $#, $*, $@

# # ROCKET_NAME=Chandrayaan
a=10
b=20
c=30

echo value of a is $a
echo value of b is $b
echo value of c is $c]

echo $0
echo "Executed script name is : $0

echo "Iam learding $1"
echo "to learn devops it needs $2
echo "iam getting trained on $3


#  bash scriptName.sh  arg1  arg2  arg3
# bash arg1  arg2  arg3 arg4  arg5  arg6 arg7  arg8  arg9  arg10 
#        1     2     3    4    5     6    7      8    9      10

# bash scriptName.sh 100   200   300    ( like this you can supply a maximum of 9 variables from the command line)
#                     $1    $2    $3  


cho $$    # $$ is going to print the PID of the current proces 
echo $#    # $# is going to print the number of arguments
echo $?    # $? is going to print the exit code of the last command.
echo $*    # $* is going to print the used arguments
echo $@    # $* is going to print the used arguments