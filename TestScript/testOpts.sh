#test.sh

#!/bin/bash

# while getopts "a:bc" arg #选项后面的冒号表示该选项需要参数
# do
#         case $arg in
#              a)
#                 echo "a's arg:$OPTARG" #参数存在$OPTARG中
#                 ;;
#              b)
#                 echo "b"
#                 ;;
#              c)
#                 echo "c"
#                 ;;
#              ?)  #当有不认识的选项的时候arg为?
#             echo "unkonw argument"
#         exit 1
#         ;;
#         esac
# done



while true ; do
        case "$1" in
                -a|--a-long) echo "Option a" ; shift ;;
                -b|--b-long) echo "Option b, argument \`$2'" ; shift 2 ;;
                -c|--c-long)
                        # c has an optional argument. As we are in quoted mode,
                        # an empty parameter will be generated if its optional
                        # argument is not found.
                        case "$2" in
                                "") echo "Option c, no argument"; shift 2 ;;
                                *)  echo "Option c, argument \`$2'" ; shift 2 ;;
                        esac ;;
                --) shift ; break ;;
                *) echo "Internal error!" ; exit 1 ;;
        esac
done
echo "Remaining arguments:"
for arg do
   echo '--> '"\`$arg'" ;
done