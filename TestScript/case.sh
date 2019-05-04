#!/bin/sh
#create by oldboy
#time :19:14 2012-3-21
#Source function library.
. /etc/init.d/functions
#config file path
FILE_PATH=/etc/openvpn_authfile.conf       #<==这是openvpn的登录授权文件路径。
[ ! -f $FILE_PATH ] && touch $FILE_PATH       #<==如果变量对应的文件不存在，则创建文件。
usage(){                                   #<==帮助函数。
    cat <<EOF                            #<==这是一个可以替代echo的输出菜单等内容的方法。
    USAGE: `basename $0` {-add|-del|-search} username
EOF
}
#judge run user
if [ $UID -ne 0 ] ;then       #<==必须是root用户，才能执行本脚本。
    echo "Youare not supper user,please call root!"
    exit 1;
fi
#judge arg numbers.
if [ $# -ne 2 ] ;then       #<==传入的参数必须为两个。
    usage
    exit 2
fi
#满足条件后进入case语句判断。
case "$1" in              #<==获取命令行第一个参数的值。
    -a|-add)              #<==如果匹配-a或-add，则执行下面的命令语句。
        shift              #<==将$1清除，将$2替换为$1，位置参数左移。
        if grep "^$1$" ${FILE_PATH} >/dev/null 2>&1       #<==过滤命令行第一个参数的值，如果有
          then              #<==则执行下面的指令。
            action $"vpnuser,$1 is exist" /bin/false
            exit
         else              #<==如果文件中不存在命令行传参的一个值，则执行下面的指令
         	chattr -i ${FILE_PATH}       #<==解锁文件。
         	/bin/cp ${FILE_PATH} ${FILE_PATH}.$(date +%F%T)
#<==备份文件（尾部加时间）。
            echo "$1" >> ${FILE_PATH}       #<==将第一个参数（即用户名）加入到文件。
            [ $ -eq 0 ] && action $"Add $1" /bin/true     #<==如果返回值为0，提
                                                              示成功。
            chattr +i ${FILE_PATH}       #<==给文件加锁。
        fi
        ;;
    -d|-del)       #<==如果命令行的第一个参数匹配-d或-del，则执行下面的命令语句。
        shift
        if [ `grep "\b$1\b" ${FILE_PATH}|wc -l` -lt 1 ]       #<==过滤第一个参数值，
                                                             并看文件中是否存在。
          then       #<==如果不存在，则执行下面的指令。
            action $"vpnuser,$1 is not exist." /bin/false
            exit
        else       #<==否则执行下面的指令，存在才删除，不存在就提示不存在，不需要删除。
            chattr -i ${FILE_PATH}              #<==给文件解锁，准备处理文件的内容。
            /bin/cp ${FILE_PATH} ${FILE_PATH}.$(date +%F%T)
#<==备份文件（尾部加时间）。
            sed -i "/^${1}$/d" ${FILE_PATH}       #<==删除文件中包含命令行传参的用户。
            [ $ -eq 0 ] && action $"Del $1" /bin/true
#<==如果返回值为0，提示成功。
            chattr +i ${FILE_PATH}              #<==给文件加锁。
            exit
        fi
        ;;
    -s|-search)       #<==如果命令行的第一个参数匹配-s或-search，就执行下面的命令语句。
        shift
        if [ `grep -w "$1" ${FILE_PATH}|wc -l` -lt 1 ]
#<==过滤第一个参数值，并看文件中是否存在。
          then
            echo $"vpnuser,$1 is not exist.";exit
        else
            echo $"vpnuser,$1 is exist.";exit
        fi
        ;;
    *)
        usage
        exit
        ;;
esac