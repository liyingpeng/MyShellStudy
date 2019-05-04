# !/bin/bash
cat <<END #<==利用cat命令打印选择菜单，这里也可以用select语句打印选择菜单。
    1.[install lamp]
    2.[install lnmp]
    3.[exit]
    pls input the num you want:
END
read num #<==接收用户选择的数字。
expr $num + 1 &>/dev/null     #<==判断是否为整数。
[ $? -ne 0 ] &&{              #<==根据返回值进行判断。
    echo "the num you input must be {1|2|3}"
    exit 1
}
[ $num -eq 1 ] &&{            #<==如果用户选择1，则执行lamp安装命令。
    echo "start installing lamp."
    sleep 2
    [ -x "$path/lamp.sh" ]||{ #<==判断脚本是否可执行，若不可执行则给予提示。
        echo "$path/lamp.sh does not exist or can not be exec."
        exit 1
    }
    $path/lamp.sh #<==执行脚本安装脚本，工作中建议用source $path/lamp.sh替代，这里的目的是练习-x的判断。
    #source $path/lamp.sh #<==脚本中执行脚本，使用source比sh或不加解释器等更好一些。
    exit $?
}
[ $num -eq 2 ] &&{            #<==如果用户选择2，则执行lnmp安装命令。
    echo "start installing LNMP."
    sleep 2;

    [ -x "$path/lnmp.sh" ]||{ #<==判断脚本是否可执行，若不可执行则给予提示。
        echo "$path/lnmp.sh does not exist or can not be exec."
        exit 1
    }
    $path/lnmp.sh #<==执行脚本安装脚本，工作中建议用source $path/lamp.sh替代，这里的目的是练习-x的判断。
    #source $path/lnmp.sh #<==脚本中执行脚本，使用source比使用sh或不加解释器等更好一些。
    exit $?
}

[ $num -eq 3 ] &&{ #<==如果用户输入3，则退出脚本。
    echo bye.
    exit 3
}
#这里有三种用户的输入不等于1、2或3的综合用法。
[[ ! $num =~ [1-3] ]] &&{ #<==[[]]的正则匹配方法。
    echo "the num you input must be {1|2|3}"
    echo "Input ERROR"
    exit 4
}