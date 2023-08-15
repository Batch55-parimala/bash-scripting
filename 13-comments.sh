#!/bin/bash

# when ever we dont want somethig to be executed in the scriopt we use comments

<<COMMENT
echo "Cloud DevOps Training"
echo "Shall Scripting"
a=100
b=300
echo $a
COMMENT
echo $b 


# This is an example of Multi-line Comment, whatever we have enclosed in between <<COMMENT    COMMENT will be marked as comment