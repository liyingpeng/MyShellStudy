# !/bin/bash

menu(){
cat <<END #<==这里的cat用法就是官方所说的here文档用法，其实就是按指定格式打印多行文本。
	1.[install lamp]
    2.[install lnmp]
    3.[exit]
    pls input the num you want:
END
#<==注意顶格写，开头不要带有空格，END成对出现，可以用任意的成对字符来替代，不要和内容冲突即可。
}
menu

read -p "Which do you like?Pls input the num:" a  #<==读入用户的选择，赋值给变量a。
[ "$a" = "1" ] &&{  #<==条件表达式判断a的值是否为1，注意，这里推荐用字符串的语法格式判断。
    echo "I guess,you like panxiaoting"  #<==根据用户选择的结果，回应应用输出。
    exit 0 #<==退出脚本，不再向下执行。
}
[ "$a" = "2" ] &&{ #<==条件表达式判断a的值是否为2。
    echo "I guess,you like gongli"
    exit 0  #<==退出脚本，不再向下执行。
}
[ "$a" = "3" ] &&{ #<==条件表达式判断a的值是否为3。
    echo "I guess,you like fangbingbing"
    exit 0  #<==退出脚本，不再向下执行。
}
[[ ! "$a" =~ [1-3] ]] &&{  #<==这里就是用到了[[]]的通配符匹配的用法，即a是否为1或2或3。
    echo "I guess,you are not man."
}