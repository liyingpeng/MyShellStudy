#!/bin/bash

# 注意gitme push 操作 会全量提交改动到远端，需要自己检查修改，以免提交不必要改动
# todo 添加确认阻塞操作，避免不小心提交过多内容
[ "$1" = 'push' ] && {
	git add -A
    git commit -m "$2"
    git push
    exit 0
}

[ "$1" = 'commit' ] && {
	git add .
   	git commit -m "$2"
    exit 0
}

[ "$1" = 'open' ] && {
	open *.xcodeproj
    exit 0
}

[ "$1" = 'fetch' ] && {
	# 获取当前分支名
	currentBranch=`git symbolic-ref --short -q HEAD`
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
[ "$1" = 'pull' ] && {
	# 获取当前分支名
	currentBranch=`git symbolic-ref --short -q HEAD`
	[ "$2" = '-o' ] && {
		git fetch origin $currentBranch
		git rebase origin/$currentBranch
		exit 0
	}
	[ "$2" = '-u' ] && {
		git fetch upstream $currentBranch
		git rebase upstream/$currentBranch
		exit 0
	}

# 默认执行 -o 操作
	git fetch origin $currentBranch
	git rebase origin/$currentBranch
    exit 0
}

# 默认没有命中任何参数直接gst
git st
exist 1
