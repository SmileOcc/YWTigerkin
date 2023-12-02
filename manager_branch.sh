#!/bin/sh

# 使用方法:
# step1: 将该脚本放在工程的根目录下（跟.xcworkspace文件or .xcodeproj文件同目录）
# step2: 根据情况修改下面的参数
# step3: 打开终端，执行脚本。（输入sh，然后将脚本文件拉到终端，会生成文件路径，然后enter就可）

# =============项目自定义部分(自定义好下列参数后再执行该脚本)=================== #

# 是否编译工作空间 (例:若是用Cocopods管理的.xcworkspace项目,赋值true;用Xcode默认创建的.xcodeproj,赋值false)
is_workspace="true"

# .xcworkspace的名字，如果is_workspace为true，则必须填。否则可不填
workspace_name="YWTigerkin"     #XXX 就是你.xcworkspace工程的名称

# .xcodeproj的名字，如果is_workspace为false，则必须填。否则可不填
project_name="YWTigerkin"          #XXX 就是你.xcodeproj工程的名称

# 指定项目的scheme名称（也就是工程的target名称），必填
#scheme_name="YWTigerkin"      #xxx 就是你工程里面某个target的scheme名称

echo "-------------------------输入target的scheme名称-----------------------------"
echo "\033[36;1m请输入您的项目target的scheme名称(大小写区分，务必和工程中的配置一致,按回车即可) \033[0m"
# 读取用户输入并存到变量里
#read targetName
#sleep 0.5

targetName="YWTigerkin"

scheme_name="$targetName"

echo "\033[33;1m您的项目target的scheme名称为=${scheme_name} "



# =======================脚本的一些固定参数定义(无特殊情况不用修改)====================== #

# 获取当前脚本所在目录
script_dir="$( cd "$( dirname "$0"  )" && pwd  )"
# 工程根目录
project_dir=$script_dir

echo "--------------------脚本 可用于脚本切换分支 打包-------------------"
echo "\033[33;1mproject_dir=${project_dir}"
#!/bin/bash




#!/bin/bash

# 执行git status，查询所有改变的文件

changeMsggg = `git status`
echo "$changeMsggg"
    
git status
echo "---------------------------------------"

# 获取所有改变的文件列表
files=$(git diff --name-only)

# 显示每个改变的文件的diff，并提示用户是否add该文件
for file in $files
do
  echo "---------------------------------------"
  echo "文件: $file"
  git diff $file
  read -p "是否add该文件？(y/n): " choice
  if [ "$choice" == "y" ]; then
    git add $file
    echo "已add文件: $file"
  else
    echo "未add文件: $file"
  fi
done









# 1. 创建一个包含所有 Git 仓库路径的数组
git_repos=(
    "/path/to/repo1"
    "/path/to/repo2"
    "/path/to/repo3"
    # ...
)

# 2. 遍历数组中的每个 Git 仓库路径
for repo in "${git_repos[@]}"; do
    echo "处理 Git 仓库: $repo"
    cd "$repo"

    # 3. 检查 Git 状态并丢弃所有修改
    
    changeMsg = `git reset --hard`
    echo "$changeMsg"
    git reset --hard
    git clean -fd

    # 4. 检查是否有 "release/2023_New_2302" 分支
    git fetch
    if git rev-parse --verify release/2023_New_2302 >/dev/null 2>&1; then
        # 5.2. 切换到 "release/2023_New_2302" 分支并更新
        git checkout release/2023_New_2302
        git pull
    else
        # 5.1. 从远端拉下 "release/2023_New_2302" 分支
        git checkout -b release/2023_New_2302 origin/release/2023_New_2302
    fi

    # 6. 检查是否有 "release/2023_New_Release_MR2302" 分支
    git fetch
    if git rev-parse --verify release/2023_New_Release_MR2302 >/dev/null 2>&1; then
        echo "分支 release/2023_New_Release_MR2302 已经存在"
    else
        # 7. 创建 "release/2023_New_Release_MR2302" 分支并推送到远程仓库
        git checkout -b release/2023_New_Release_MR2302
        if git push --set-upstream origin release/2023_New_Release_MR2302; then
            echo "分支 release/2023_New_Release_MR2302 创建成功"
        else
            echo "分支 release/2023_New_Release_MR2302 创建失败，可能已经存在"
        fi
    fi
done


echo "\n\n"
echo "\033[32m+++++++++++++++++获取：git 提交记录 ++++++++++++++++ \033[0m"

#蒲公英版本更新描述，这里取git最后一条提交记录作为描述
#Last_MSG=`git log -1 --pretty=%B`
#echo "git last msg: $Last_MSG"
#
###从2021-06-05->2021-06-08
#Log_MSG=`git log --oneline --no-merges --since="2021-06-05" --until="2021-06-08" | awk '{$1="";print $0}'`
#Log_MSG="[jenkins]-----$Log_MSG-----[jenkins]"
#echo "从2021-06-05->2021-06-08: $Log_MSG"
#
###一秒之前，48小时之内
#Log_MSG=`git log --oneline --no-merges --before={1.seconds.ago} --after={48.hours.ago} | awk '{$1="";print $0}'`
#echo "一秒之前，48小时之内:$Log_MSG"
#
###一秒之前，2021-06-07之后
#Log_MSG=`git log --oneline --no-merges --before={1.seconds.ago} --after={2021-06-07} | awk '{$1="";print $0}'`
#echo "一秒之前，2021-06-07之后:$Log_MSG"

##一天之前
#Log_MSG=`git log --oneline --no-merges --before={1.days} | awk '{$1="";print $0}'`
#echo "一天之前:$Log_MSG"

##三天之内
Log_MSG=`git log --oneline --no-merges --after={3.days} | awk '{$1="";print $0}'`
echo "三天之内:$Log_MSG"

##最近一天的代码提交情况
#Log_MSG=`git log --since=1.days`
#echo "最近一天的代码提交情况:$Log_MSG"

##最近一周的代码提交情况
#Log_MSG=`git log --since=1.weeks`
#echo "最近一周的代码提交情况:$Log_MSG"

##最近两次的代码提交情况
#Log_MSG=`git log -p -2`
#echo "最近两次的代码提交情况:$Log_MSG"


exit 0

