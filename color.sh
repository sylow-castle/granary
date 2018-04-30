#!/usr/bin/bash

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
