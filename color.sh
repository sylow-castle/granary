#!/usr/bin/bash

usage=`cat << EOS
<概要>
標準入力の各行に対し、行頭の文字に合わせてその行の文字色を変更します。
行頭の文字：文字色
+：赤色
-：緑色
その他：デフォルト色

<オプション>
 -h, --help：このヘルプを表示します。
EOS
`

while getopts ":h-:" opt; do
    case "$opt" in
        -)
        case "${OPTARG}" in
            help)
                #echo "helpがあ指定されました。"
                echo "$usage"
                exit 0
            ;;
        esac
        ;;
        h)
            #-help指定のケースとまとめないのは数が少ないため。
            #echo "hが指定されました。"
            echo "$usage"
            exit 0
        ;;
    esac
done

#標準入力に対して、行頭が+のときは赤く表示する
#標準入力に対して、行頭が-のときは緑に表示する
#どちらでもないときはデフォルト色で表示する
while read line
do
    #赤にするかの判定
    red=$(expr match "${line}" "^\+.*$")
    if [ $red -gt 0 ]; then
        echo -ne "\e[31m"
        echo -n "${line}"
        echo -e "\e[m"
    else
        #緑にするかの判定
        green=$(expr match "${line}" "^\-.*$")
        if [ $green -gt 0 ]; then
            echo -ne "\e[32m"
            echo -n "${line}"
            echo -e "\e[m"
        else
            echo "${line}"
        fi
    fi
done
