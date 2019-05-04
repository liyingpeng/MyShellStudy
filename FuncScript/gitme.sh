#!/bin/bash

[ "$1" = 'push' ] && {
	git add -A
    git commit -m "$2"
    git push
    exist 0
}

[ "$1" = 'commit' ] && {
	git add .
   	git commit -m "$2"
    exist 0
}

[ "$1" = 'open' ] && {
	open *.xcodeproj
    exist 0
}

git st
exist 1