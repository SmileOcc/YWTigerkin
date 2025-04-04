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

#分支切换

echo "-------------------------选择打包方式-----------------------------"
echo "\033[36;1m请选择打包方式(输入序号,按回车即可) \033[0m"
echo "\033[33;1m1. YWTigerkin       \033[0m"
echo "\033[33;1m2. YWTigerkin.prd    \033[0m"
echo "\033[33;1m3. YWTigerkin.test  \033[0m"
echo "\033[33;1m4. YWTigerkin.dev \033[0m"
# 读取用户输入并存到变量里
read shceme_branch_input
sleep 0.5

shceme_branch="$shceme_branch_input"

# 判读用户是否有输入
if [ -n "$shceme_branch" ]
then
    if [ "$shceme_branch" = "1" ] ; then
        scheme_name="YWTigerkin"
    elif [ "$shceme_branch" = "2" ] ; then
        scheme_name="YWTigerkin.prd"
    elif [ "$shceme_branch" = "3" ] ; then
        scheme_name="YWTigerkin.test"
    elif [ "$shceme_branch" = "4" ] ; then
        scheme_name="YWTigerkin.dev"
    else
        echo "输入的参数无效!!!"
        exit 1
    fi
fi


# 指定要打包编译的方式 : Release,Debug。一般用Release。必填
build_configuration="Release"

echo "-------------------------选择打包方式-----------------------------"
echo "\033[36;1m请选择打包方式(输入序号,按回车即可) \033[0m"
echo "\033[33;1m1. Debug       \033[0m"
echo "\033[33;1m2. Release    \033[0m"

# 读取用户输入并存到变量里
read parameter_buid
sleep 0.5

buidMeth="$parameter_buid"

# 判读用户是否有输入
if [ -n "$buidMeth" ]
then
    if [ "$buidMeth" = "1" ] ; then
        build_configuration="Release"
    elif [ "$buidMeth" = "2" ] ; then
        build_configuration="Debug"
    elif [ "$packMethod" = "4" ] ; then
        build_configuration="Debug"
    else
        echo "输入的参数无效!!!"
        exit 1
    fi
fi


# method，打包的方式。方式分别为 development, ad-hoc, app-store, enterprise 。必填

#method="ad-hoc"

echo "-------------------------选择打包方式-----------------------------"
echo "\033[36;1m请选择打包方式(输入序号,按回车即可) \033[0m"
echo "\033[33;1m1. AdHoc       \033[0m"
echo "\033[33;1m2. AppStore    \033[0m"
echo "\033[33;1m3. Enterprise  \033[0m"
echo "\033[33;1m4. Development \033[0m"
# 读取用户输入并存到变量里
read parameter
sleep 0.5

packMethod="$parameter"

# 判读用户是否有输入
if [ -n "$packMethod" ]
then
    if [ "$packMethod" = "1" ] ; then
        method="ad-hoc"
    elif [ "$packMethod" = "2" ] ; then
        method="app-store"
    elif [ "$packMethod" = "3" ] ; then
        method="enterprise"
    elif [ "$packMethod" = "4" ] ; then
        method="development"
    else
        echo "输入的参数无效!!!"
        exit 1
    fi
fi


echo "\033[33;1m打包方式method=${method} "

echo "\n\n"
app_branch=`git rev-parse --abbrev-ref HEAD`
echo "【代码版本分支】✅✅✅✅✅:$app_branch"
echo

if [ "$method" = "app-store" ] ; then
    if [ -n "$app_branch" ]; then
        if [ "$app_branch" = "dev_release" ]; then
        else
            echo "【校验线上打包：代码版本分支】❌❌❌❌:$app_branch ----> cd进入项目路径下打包， 打线上包需要【dev_release】分支"
            exit 1
        fi
    else
        echo "【未读取分支 校验线上打包：代码版本分支】❌❌❌❌:$app_branch ----> cd进入项目路径下打包， 打线上包需要【dev_release】分支"
        exit
    fi
fi


#  下面两个参数只是在手动指定Pofile文件的时候用到，如果使用Xcode自动管理Profile,直接留空就好
# (跟method对应的)mobileprovision文件名，需要先双击安装.mobileprovision文件.手动管理Profile时必填
mobileprovision_name="iPhone Distribution: Shenzhen Inovance Technology Co., Ltd."

# 项目的bundleID，手动管理Profile时必填
#bundle_identifier="com.od.ywtigerkin"
#调试这个可以打包成功
bundle_identifier="com.od.ywtigerkin.dev"





echo "--------------------脚本配置参数检查--------------------"
echo "\033[33;1mis_workspace=${is_workspace} "
echo "workspace_name=${workspace_name}"
echo "project_name=${project_name}"
echo "scheme_name=${scheme_name}"
echo "build_configuration=${build_configuration}"
echo "bundle_identifier=${bundle_identifier}"
echo "method=${method}"
echo "mobileprovision_name=${mobileprovision_name} \033[0m"



echo "-------------------------选择发布平台-----------------------------"
echo "\033[36;1m请选择发布平台(输入序号,按回车即可) \033[0m"
echo "\033[33;1m1. AppStore      \033[0m"
echo "\033[33;1m2. 蒲公英pgyer    \033[0m"
echo "\033[33;1m3. fir平台  \033[0m"
echo "\033[33;1m4. 不发布 \033[0m"
# 读取用户输入并存到变量里
read uploadTypeParameter

sleep 0.5

uploadType="$uploadTypeParameter"

# 是否上传分发平台(fir)
is_uploadfir="true"

# firToken
fir_token="xxxxxx"     # xxxxxx  就是你fir平台上token
upload_token=$fir_token

# 蒲公英上传
# 执行 curl -F "file=@xxxxxxx.ipa" -F "uKey=xxx" -F "_api_key=xxx" https://www.pgyer.com/apiv2/app/upload      请根据开发者自己的账号，将其中的 uKey 和 _api_key 的值替换为相应的值。




# =======================脚本的一些固定参数定义(无特殊情况不用修改)====================== #

# 获取当前脚本所在目录
script_dir="$( cd "$( dirname "$0"  )" && pwd  )"
# 工程根目录
project_dir=$script_dir

# 时间
DATE=`date '+%Y%m%d_%H%M%S'`
# 指定输出导出文件夹路径
export_path="$project_dir/Package/$scheme_name-$DATE"
# 指定输出归档文件路径
export_archive_path="$export_path/$scheme_name.xcarchive"
# 指定输出ipa文件夹路径
export_ipa_path="$export_path"
# 指定输出ipa名称
ipa_name="${scheme_name}_${DATE}"
# 指定导出ipa包需要用到的plist配置文件的路径
export_options_plist_path="$project_dir/ExportOptions.plist"


echo "--------------------脚本固定参数检查--------------------"
echo "\033[33;1mproject_dir=${project_dir}"
echo "DATE=${DATE}"
echo "export_path=${export_path}"
echo "export_archive_path=${export_archive_path}"
echo "export_ipa_path=${export_ipa_path}"
echo "export_options_plist_path=${export_options_plist_path}"
echo "ipa_name=${ipa_name} \033[0m"


echo "\n\n"
echo "\033[32m+++++++++++++++++开始创建：export_options_plist+++++++++++++++++\033[0m"

# 先删除export_options_plist文件
if [ -f "$export_options_plist_path" ] ; then
    #echo "${export_options_plist_path}文件存在，进行删除"
    rm -f $export_options_plist_path
fi
# 根据参数生成export_options_plist文件
/usr/libexec/PlistBuddy -c  "Add :method String ${method}"  $export_options_plist_path
#/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:"  $export_options_plist_path
#/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:${bundle_identifier} String ${mobileprovision_name}"  $export_options_plist_path
#旧
#/usr/libexec/PlistBuddy -c  "Add :signingStyle String automatic"  $export_options_plist_path
#新
/usr/libexec/PlistBuddy -c  "Add :signingStyle String manual"  $export_options_plist_path
/usr/libexec/PlistBuddy -c  "Add :destination String export"  $export_options_plist_path
/usr/libexec/PlistBuddy -c  "Add :compileBitcode bool false"  $export_options_plist_path     #如果您的工程是开启Bitcode的话，请把false改为true

echo "\033[31;1mexport_options_plist文件: ${export_options_plist_path}       \033[0m"


# =======================自动打包部分(无特殊情况不用修改)====================== #

echo "------------------------------------------------------"
echo "\033[32m开始构建项目  \033[0m"
# 进入项目工程目录
cd ${project_dir}

# 指定输出文件目录不存在则创建
if [ -d "$export_path" ] ; then
    echo $export_path
else
    mkdir -pv $export_path
fi

# 判断编译的项目类型是workspace还是project
if $is_workspace ; then
# 编译前清理工程
xcodebuild clean -workspace ${workspace_name}.xcworkspace \
                 -scheme ${scheme_name} \
                 -configuration ${build_configuration}

xcodebuild archive -workspace ${workspace_name}.xcworkspace \
                   -scheme ${scheme_name} \
                   -configuration ${build_configuration} \
                   -archivePath ${export_archive_path}
else
# 编译前清理工程
xcodebuild clean -project ${project_name}.xcodeproj \
                 -scheme ${scheme_name} \
                 -configuration ${build_configuration}

xcodebuild archive -project ${project_name}.xcodeproj \
                   -scheme ${scheme_name} \
                   -configuration ${build_configuration} \
                   -archivePath ${export_archive_path}
fi

#  检查是否构建成功
#  xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if [ -d "$export_archive_path" ] ; then
    echo "\033[32;1m项目构建成功 🚀 🚀 🚀  \033[0m"
else
    echo "\033[31;1m项目构建失败 😢 😢 😢  \033[0m"
    exit 1
fi
echo "------------------------------------------------------"

echo "\033[32m开始导出ipa文件 \033[0m"


xcodebuild  -exportArchive \
            -archivePath ${export_archive_path} \
            -exportPath ${export_ipa_path} \
            -exportOptionsPlist ${export_options_plist_path} \
            -allowProvisioningUpdates

# 检查ipa文件是否存在
if [ -f "$export_ipa_path/$scheme_name.ipa" ] ; then
    echo "\033[32;1mexportArchive ipa包成功,准备进行重命名\033[0m"
else
    echo "\033[31;1mexportArchive ipa包失败 😢 😢 😢     \033[0m"
    exit 1
fi

# 修改ipa文件名称
mv $export_ipa_path/$scheme_name.ipa $export_ipa_path/$ipa_name.ipa

# 检查文件是否存在
if [ -f "$export_ipa_path/$ipa_name.ipa" ] ; then
    echo "\033[32;1m导出 ${ipa_name}.ipa 包成功 🎉  🎉  🎉   \033[0m"
    open $export_path
else
    echo "\033[31;1m导出 ${ipa_name}.ipa 包失败 😢 😢 😢     \033[0m"
    exit 1
fi

# 删除export_options_plist文件（中间文件）
if [ -f "$export_options_plist_path" ] ; then
    #echo "${export_options_plist_path}文件存在，准备删除"
    rm -f $export_options_plist_path
fi

# 输出打包总用时
echo "\033[36;1m使用AutoPackageScript打包总用时: ${SECONDS}s \033[0m"



if [ "$uploadType" = "1" ] ; then
   echo "App Store发布!!!"
   xcrun altool --validate-app -f $export_ipa_path/$ipa_name.ipa -t ios --apiKey xxx --apiIssuer xxx  --verbose
   xcrun altool --upload-app -f $export_ipa_path/$ipa_name.ipa -t ios --apiKey xxx --apiIssuer xxx --verbose

   # xxx 就是你App Store管理后台的秘钥和apiKey信息

elif [ "$uploadType" = "2" ] ; then
    curl -F "file=@$export_ipa_path/$ipa_name.ipa" -F "uKey=xxx" -F "_api_key=xxx" https://www.pgyer.com/apiv2/app/upload
elif [ "$uploadType" = "3" ] ; then
   fir login -T $upload_token       # fir.im token
   fir publish $export_ipa_path/$ipa_name.ipa
else
    echo "不发布!!!"
    exit 0
fi


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




#echo "\n\n"
#echo "\033[32m+++++++++++++++++ 开始上传到蒲公英 ++++++++++++++++ \033[0m"
#echo "上传ipa文件路径：${EXPORT_IPA_PATH_FILE}"
##上传到蒲公英
##蒲公英aipKey
#MY_PGY_API_K="399cedfde855c67ff5393fd95d0340a1"
##蒲公英uKey
#MY_PGY_UK="de20cf81a02f12b2577b6c6fca70ab98"
#
#curl -F "file=@$EXPORT_IPA_PATH_FILE" -F "uKey=$MY_PGY_UK" -F "_api_key=$MY_PGY_API_K" -F "updateDescription=$Log_MSG"  https://www.pgyer.com/apiv1/app/upload
#
#echo "\n\n"
#echo "\033[32m+++++++++++++++++ 已运行完毕 ++++++++++++++++ \033[0m"




echo "\n\n"
echo "================= 删除文件 ================="


#删除归档文件 ExportOptions.plist (使用方式二时，可以打开）
#rm -r -f "${export_archive_path}"

#删除归档文件 xxx.xcarchive
#rm -r -f "${export_path}"
#
## 删除文件 Packaging.log
#rm -r -f "${export_ipa_path}"
echo "\033[32m+++++++++++++++++ 删除文件完毕 ++++++++++++++++ \033[0m"

echo "\n\n"

exit 0

