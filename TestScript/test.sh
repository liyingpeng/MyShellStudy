# !bin/bash

# Date：   16:29 2012-3-30
# Author： Created by liyingpeng
# Blog:http://oldboy.blog.51cto.com
# Description：This scripts function is.....
# Version：1.1
a=192.168.1.2
b='192.168.1.2'
c="192.168.1.2"
echo "a=$a"
echo "b=$b"
echo "c=${c}"

a=192.168.1.2-$a
b='192.168.1.2-$a'
c="192.168.1.2-$a"
echo "a=$a"
echo "b=$b"
echo "c=${c}"
