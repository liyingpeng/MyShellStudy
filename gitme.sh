#!/bin/bash

if [[ "$1" = "push" ]]; then
	git add .
    git commit -m "$2"
    git push
elif [[ "$1" == "commit" ]]; then
	git add .
   	git commit -m "$2"
elif [[ "$1" == "open" ]]; then
	open *.xcodeproj
else
	git st
fi