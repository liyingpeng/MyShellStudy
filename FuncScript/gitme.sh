#!/bin/bash

# shell 语句出错或者异常自动退出 不继续执行set -e 、set -o errexit
set -o errexit

# 注意gitme push 操作 会全量提交改动到远端，需要自己检查修改，以免提交不必要改动
# todo 添加确认阻塞操作，避免不小心提交过多内容
# todo 添加-pr参数（参数判断）
[ "$1" = 'push' ] && {
	# 获取当前分支名
	currentBranch=`git symbolic-ref --short -q HEAD`

	git add -A
    git commit -m "$2"
    git push --set-upstream origin $currentBranch
    exit 0
}

# 该命令只应该用于创建分支后 提交到远端 不应带任何修改信息
[ "$1" = 'pushtoupstream' ] && {
	# 获取当前分支名
	currentBranch=`git symbolic-ref --short -q HEAD`
    git push --set-upstream upstream $currentBranch
	git branch --set-upstream-to=origin/$currentBranch
    exit 0
}

[ "$1" = 'commit' ] && {
	git add .
   	git commit -m "$2"
    exit 0
}

[ "$1" = 'open' ] && {
	open *.xcworkspace
    exit 0
}

[ "$1" = 'fetch' ] && {
	# 获取当前分支名
	currentBranch=`git symbolic-ref --short -q HEAD`

	git branch --set-upstream-to=origin/$currentBranch

	[ "$2" = '-o' ] && {
		git fetch origin $currentBranch
		exit 0
	}
	[ "$2" = '-u' ] && {
		git fetch upstream $currentBranch
		exit 0
	}

# 默认执行-o操作
	git fetch origin $currentBranch
    exit 0
}

# 默认gitme 以 rebase方式 合并
# TODO 添加错误处理 如果没有upstream 分支怎么办
# TODO 如何自动判断要不要install，判断更新文件中有没有podfile?，是否可以使用awk sed？
[ "$1" = 'pull' ] && {
	# 过滤掉第一个pull 参数
	shift

	# 获取当前分支名
	currentBranch=`git symbolic-ref --short -q HEAD`
	targetBranch=$currentBranch

	git branch --set-upstream-to=origin/$currentBranch

	hasSetupFetchType=false
	shouldMerge=false

	while getopts "b:moupi" arg #选项后面的冒号表示该选项需要参数
	do
        case $arg in
        	b) 
				if [ -n $OPTARG ]; then
					targetBranch=$OPTARG
				fi
				;;
			m)
				shouldMerge=true
				;;
        	o)
				hasSetupFetchType=true
                git fetch origin $targetBranch
                if [ "$shouldMerge" = true ]; then
					git merge origin/$targetBranch
				else
					git rebase origin/$targetBranch
				fi
                ;;
            u)
				hasSetupFetchType=true
                git fetch upstream $targetBranch
				if [ "$shouldMerge" = true ]; then
					git merge upstream/$targetBranch
				else
					git rebase upstream/$targetBranch
				fi
                ;;
	        p)
                git push --set-upstream origin $currentBranch
                ;;
            i)
                pod install
                ;;
            ?)  #当有不认识的选项的时候arg为?
	            echo "unkonw argument"
		        exit 1
		        ;;
        esac
	done

	if [ "$hasSetupFetchType" = false ]; then
		# 默认执行 -o 操作
		git fetch origin $targetBranch
		if [ "$shouldMerge" = true ]; then
			git merge origin/$targetBranch
		else
			git rebase origin/$targetBranch
		fi
	fi

	gitme open
	exit 0
}

# TODO: gitlab merge_request docs : https://docs.gitlab.com/ee/api/merge_requests.html
[ "$1" = 'pr' ] && {
	# 获取当前分支名
	currentBranch=`git symbolic-ref --short -q HEAD`
	targetBranch=""
	if [ ! -n "$2" ]; then
		targetBranch=$currentBranch
	else
		targetBranch=$2
	fi

	webUrl="https://gitlab.p1staff.com/liyingpeng/putong-ios/merge_requests/new?utf8=%E2%9C%93&merge_request%5Bsource_project_id%5D=675&merge_request%5Bsource_branch%5D=${currentBranch}&merge_request%5Btarget_project_id%5D=269&merge_request%5Btarget_branch%5D=${targetBranch}"

	open $webUrl

    exit 0
}

[ "$1" = 'install' ] && {
	pod install
	gitme open
    exit 0
}

[ "$1" = 'co' ] && {
	[ "$2" = '-b' ] && {
		git co -b "$3"
		git push --set-upstream origin "$3"
		exit 0
	}
	git co "$2"
    exit 0
}
