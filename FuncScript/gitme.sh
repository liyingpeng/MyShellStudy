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
# TODO 如何自动判断要不要install，判断更新文件中有没有podfile?，是否可以使用awk sed？
[ "$1" = 'pull' ] && {
	# 获取当前分支名
	currentBranch=`git symbolic-ref --short -q HEAD`
	targetBranch=$currentBranch

	git branch --set-upstream-to=origin/$currentBranch

	hasSetupFetchType=false
	shouldMerge=false

	# 取参数前 过滤掉第一个pull 参数
	shift

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
	
	exit 0
}

[ "$1" = 'pr' ] && {
	source_project_id=675
	target_project_id=269
	source_branch=`git symbolic-ref --short -q HEAD`
	target_branch=$source_branch

    oldIFS=$IFS
	IFS=,
	description=$(cat ~/pr_b.txt)

	# 取参数前 过滤掉第一个 参数
	shift

	while getopts "b:fc" arg #选项后面的冒号表示该选项需要参数
	do
        case $arg in
        	b) 
				if [ -n $OPTARG ]; then
					target_branch=$OPTARG
				fi
				;;
			f)
				description=$(cat ~/pr_f.txt)
				;;
        	c)
				description=$(cat ~/pr_c.txt)
                ;;
            ?)  #当有不认识的选项的时候arg为?
	            echo "unkonw argument"
		        exit 1
		        ;;
        esac
	done

	webUrl="https://gitlab.p1staff.com/liyingpeng/putong-ios/merge_requests/new?merge_request[source_project_id]=${source_project_id}&merge_request[source_branch]=${source_branch}&merge_request[target_project_id]=${target_project_id}&merge_request[target_branch]=${target_branch}&merge_request[description]=${description}"
	open $webUrl
	IFS=$oldIFS

    exit 0
}

[ "$1" = 'install' ] && {
	pod install
    exit 0
}

[ "$1" = 'co' ] && {
	if [ ! -n "$2" ]; then
		echo "needs argument"
		exit 1
	fi
	[ "$2" = '-b' ] && {
		git co -b "$3"
		git push --set-upstream origin "$3"
		exit 0
	}
	currentBranch=`git symbolic-ref --short -q HEAD`
	[ "$2" = $currentBranch ] && { 
		echo "already in branch"
		exit 1
	}
	searchBranch=`git branch -a | grep -w "$2" | head -n 1 | sed -e 's/^[ ]*//g'`
	if [ ! -z $searchBranch ] && [ $searchBranch = "$2" ]; then
		# 本地有该分支 直接checkout
		git co $searchBranch
	    exit 0
	fi
	# 本地没有的话直接从远端拉取
	git fetch upstream
	sourceBranch=$2
	if [ -n "$3" ]; then
		sourceBranch=$3
	fi
	git co -b "$2" upstream/$sourceBranch
	git push --set-upstream origin
    exit 0
}

[ "$1" = 'publish' ] && {
	cp `pwd`/gitme.sh  /usr/local/bin/gitme
    exit 0
}
