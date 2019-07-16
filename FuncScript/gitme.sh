#!/bin/bash

# 注意gitme push 操作 会全量提交改动到远端，需要自己检查修改，以免提交不必要改动
# todo 添加确认阻塞操作，避免不小心提交过多内容
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
	open *.xcodeproj
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
[ "$1" = 'pull' ] && {
	# 获取当前分支名
	currentBranch=`git symbolic-ref --short -q HEAD`

	git branch --set-upstream-to=origin/$currentBranch

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

	[ "$2" = '-up' ] && {
		git fetch upstream $currentBranch
		git rebase upstream/$currentBranch
		git push
		exit 0
	}

	[ "$2" = '-upi' ] && {
		git fetch upstream $currentBranch
		git rebase upstream/$currentBranch
		git push
		pod install
		exit 0
	}

# 默认执行 -o 操作
	git fetch origin $currentBranch
	git rebase origin/$currentBranch
    exit 0
}

# 默认没有命中任何参数直接gst
git st
exit 1
