#!/bin/bash

function main() {
	init
	checklldbconfig
	deploy
	require
}

function init() {
	cd $HOME
	test ! -d .platform_root && mkdir .platform_root
	cd - > /dev/null
}

function checklldbconfig() {
	cd $HOME
	cdir=`pwd`
	if [[ -f .lldbinit  ]]; then
		contain=`egrep "command script import $cdir/.platform_root/ls.py" .lldbinit`

		test -z $contain && echo "" >> .lldbinit && echo "command script import $cdir/.platform_root/ls.py" >> .lldbinit
	fi
	test ! -f .lldbinit && echo "command script import $cdir/.platform_root/ls.py" > .lldbinit
	source .lldbinit >> /dev/null
	cd - > /dev/null
}

function deploy() {
	cd $HOME/.platform_root
	curl -s -o ls.py http://tosv.byted.org/obj/iosbinary/Binary_debug/ls.py
	curl -s -o core_debug.sh http://tosv.byted.org/obj/iosbinary/Binary_debug/core_debug.sh
	ls |xargs chmod 777
	cd - > /dev/null
}

function require() {
	cd $HOME/.platform_root
	# read "desc?Do you want to update your repo :(Y/N)"
	read -s "desc?Because the operation to handle binary need the root permissions,please input your password: "
	
	local usr=`echo $desc | sudo -S whoami`
	
	if [[ "$usr" == 'root' ]]; then
		echo $desc | base64 > .root
	else
		cd - > /dev/null
		require
	fi
	echo " "
	echo "Deploy Success"
	cd - > /dev/null
}

main