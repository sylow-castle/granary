#!/usr/bin/bash

#コマンド一覧
MAIN="main"
HELP="help"

function decide_command() {

    meta="";
    command=${MAIN};
    while getopts ":h-:" opt; do
        case "$opt" in
            -)
                case "${OPTARG}" in
                    help)
                        command=${HELP}
                    ;;
                    command)
                        meta="echo "
                    ;;
                esac
            ;;
            h)
                #-help指定のケースとまとめないのは数が少ないため。
                command=${HELP}
            ;;
        esac
    done

    if [ "${meta}" = "" ] ; then
        echo "${command}"
    else
        echo 'echo '${command}
    fi
}

function help() {
    usage=`cat << EOS
<概要>
標準入力の各行に対し、行頭の文字に合わせてその行の文字色を変更します。
行頭の文字：文字色
+：赤色
-：緑色
その他：デフォルト色

<オプション>
 -h, --help：このヘルプを表示します。
 --command：-指定したオプション（除--command）で実行する処理を表示します。
    main：概要に記されている処理を実行します。
    help：このヘルプを実行します。
EOS
`
    echo "${usage}";
}

function main() {
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
}

#decide_commandでの返り値と、関数名を合わせているためにこの書き方。
#返り値と関数名を合わせないなら、以下の凝は実装変更
command=`decide_command $*`
${command}

