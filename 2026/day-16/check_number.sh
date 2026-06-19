#!/bin/bash

read -p "Enter a number: " number

if [ "$number" -gt 0 ]; then
        echo "$number is positive"
elif [ "$number" -lt 0 ]; then
        echo "$number is negative"
else
        echo "$number is Zero"
fi
