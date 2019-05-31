#!/bin/bash

[ "$1" = 'push' ] && {
	git add -A
    git commit -m "$2"
    git push
    exit 0
}

[ "$1" = 'commit' ] && {
	git add .
   	git commit -m "$2"
    exit 0
}

[ "$1" = 'open' ] && {
	open *.xcodeproj
    exit 0
}

git st
exist 1
