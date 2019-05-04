#!/bin/bash

function fun1() {
	echo "this is fun1, param is $1"
}

. /etc/init.d/functions       #<==引入系统函数库。
function usage(){
    echo $"usage:$0 url"
    exit 1
}

function check_url(){ #<==检测URL函数。
    wget --spider -q -o /dev/null --tries=1 -T 5 $1 #<==这里的$1就是函数传参。
    if [ $? -eq 0 ]
      then
        echo "$1 is yes."
    else
        echo "$1 is no."
    fi
}

function main(){ #<==主函数。
    if [ $# -ne 1 ] #<==如果传入的是多个参数，则打印帮助函数，提示用户。
      then
        usage
    fi
    check_url $1 #<==接收函数的传参，即把下文main结尾的$*传到这里。
}

main $* #<==这里的$*就是把命令行接收的所有参数作为函数参数传给函数内部，是一种常用手法