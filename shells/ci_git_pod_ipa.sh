#!/usr/bin/env sh

echo "usage `basename $0` repo branch dir "
REPO=$1
BRANCH=$2
SOURCE_DIR=$3
if [[ -z $REPO ]]; then
    REPO="http://git.letv.cn/cuihaicheng/sarrs_ios_client.git"
fi

if [[ -z $BRANCH ]]; then
    BRANCH=develop
fi
if [[ -z ${SOURCE_DIR} ]]; then
    SOURCE_DIR="source"
fi
export LANG=en_US.UTF-8
if [[ -e ${SOURCE_DIR} ]]; then
    echo 'update.........'
    cd ${SOURCE_DIR}
    # 放弃本地的修改
    git clean -df
    git checkout -- .

    # 获取最新信息
    #git pull --verbose origin master
    git checkout -B $BRANCH
    git branch --set-upstream-to=origin/$BRANCH $BRANCH
    git pull origin $BRANCH --verbose
else
    echo 'clone........'
    git clone --verbose ${REPO} ${SOURCE_DIR}
    cd ${SOURCE_DIR}
    git checkout -B $BRANCH
    git branch --set-upstream-to=origin/$BRANCH $BRANCH
fi

#PROVISIONING_PROFILE="41185ff8-7857-4561-be5d-b523759ad7b3"
#CODE_SIGN_IDENTITY="iPhone Developer: xiehui xie (T673VPKMTZ)"
ref_file="../ref"
if [[ -e "${ref_file}" ]]; then
    ref=`cat ${ref_file}`
fi

new_ref=`git rev-parse --verify HEAD`
if [[ $ref == $new_ref ]]; then
    echo "same version"
fi

echo $new_ref>${ref_file}

# 获取提交日志
if [[ -z $ref ]]; then
    notes="首次编译"
else
    notes=`git log --pretty=format:"%an %ci %s" $ref...HEAD --no-merges|sed -E 's/ \+0800//'`
fi

if [[ -z $notes ]]; then
    notes=`git log --pretty=format:"%an %ci %s" -n 3 --no-merges|sed -E 's/ \+0800//'`
fi
# 获取mobileprovision文件的UUID
# /usr/libexec/PlistBuddy -c 'Print UUID' /dev/stdin <<< $(security cms -D -i ~/Documents/All_App_Development.mobileprovision)
# echo $notes >> "../notes"
# git log --pretty="%s" --since="`date -r ./../lastSuccessful/build.xml "+%F %T"`"

exit 0
if [[ -z $ref ]]; then
    ./pod_install /usr/local/bin/pod 2>&1 1>../verbos.log
else
    diff=`git diff --dirstat=files --diff-filter=ARD $ref HEAD sub-modules`
    echo $diff
    if [[ -z $diff ]]; then
        echo 'no files changed in sub-modeles'
    else
        ./pod_install /usr/local/bin/pod 2>&1 1>../verbos.log
    fi
fi