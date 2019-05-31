#!/bin/sh
if [[ -n "$1" ]]; then
    pid=$(ps rax | awk '{print $1, $5}' | grep -i "$1" | cut -d ' ' -f 1)
    if [[ -n $pid ]]; then
        caffeinate -s -w "$pid" &
        echo "Systemp sleep prevented by $1"
    else
        echo "Sorry, the $1 could not be found."
    fi
else
    echo "Please enter the name of the program that you want to wait."
    echo "Example:"
    echo "  prevent_sleep wget"
fi