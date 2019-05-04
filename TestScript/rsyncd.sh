#!/bin/bash
# chkconfig: 2345 20 80 
# description: Rsyncd Startup scripts by oldboy.   设置开机启动

if [ $# -ne 1 ]              #<==如果传参的个数不等于1，
  then                     #<==则执行下面的命令打印语法，提示用户，并退出。
    echo $"usage:$0 {start|stop|restart}"
    exit 1
fi
if [ "$1" = "start" ]       #<==如果参数的值为start，则执行then下面的语句。
  then
    rsync --daemon       #<==启动rsync服务。
    sleep 2              #<==休息2秒，这点很重要，停止及启动服务后，建议先休息1~2秒，再判断。
    if [ `netstat -lntup|grep rsync|wc -l` -ge 1 ]
#<==如果过滤rsync字符串的行数大于1，则表示rsync服务启动了。
      then
        echo "rsyncd is started."
        exit 0
    fi
elif [ "$1" = "stop" ]       #<==如果参数的值为stop，则执行then下面的语句。
  then
    killall rsync &>/dev/null #<==停止服务，这里停止服务的方法有多种，读者可以自行选择。
    sleep 2               #<==休息2秒，再判断，防止没有停止完服务，导致判断不准确。
    if [ `netstat -lntup|grep rsync|wc -l` -eq 0 ]
#<==如果过滤rsync字符串的行数为0，则表示rsync服务停止了。
      then
        echo "rsyncd is stopped."
        exit 0
    fi
elif [ "$1" = "restart" ]       #<==如果参数的值为restart，则执行then下面的语句。
  then
    killall rsync                     #<==关闭服务。
    sleep 1
    killpro=`netstat -lntup|grep rsync|wc -l`
    rsync --daemon                            #<==启动服务。
    sleep 1
    startpro=`netstat -lntup|grep rsync|wc -l`
    if [ $killpro -eq 0 -a $startpro -ge 1 ]       #<==判断，给出提示。
      then
        echo "rsyncd is restarted."
        exit 0
    fi
else                            #<==若没有按照帮助提示传参，则给出提示并退出脚本。
    echo $"usage:$0 {start|stop|restart}"
    exit 1
fi
