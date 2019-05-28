メモ
=========


## ディレクトリ解説

* ここ
    * memo.md：これ
    * Questions.md: 問題のネタ帳
    * ctf_files：サーバに送って使う
    * id_rsa_ctf：ログインで使う。サーバに設定した公開鍵に対応する秘密鍵
    * id_rsa_ctf：ログインで使う。サーバに設定した公開鍵
* ctf_files：問題を設定するときに使うファイルを置く
    * commons：共通の設定とか
    * qs01…：各問題固有のファイル
    * playbook.yml：サーバを設定するためのAnsible Playbook
    
問題：ユーザー：ディレクトリが対応してる。

## メモ：apacheまわり

* 問題ごとのディレクトリを作る。
* ベーシック認証で各ユーザー名とフラグを対応させる

```
cd /var/www/html/
mkdir ctf
echo "congraturation!" > ctf/index.html
getent passwd | grep qs | sed 's@:@ @'| awk '{print $1}' > users
for dir_name in `cat users`; do ln -s ./ctf /var/www/html/${dir_name}; done;
```

```
#ファイル作るときはcオプション
htpasswd -c -b /etc/httpd/conf/.htpasswd example example
```