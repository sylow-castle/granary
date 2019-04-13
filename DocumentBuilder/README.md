README
=====

markdownで書類を一杯書くことになってきたけど、お客さんに出したりするときにも出せるようにしたいなぁと思い作成。どっちかというとMSBuildとMakeのお勉強が主目的

## 何故MSBuildとMake？

どっちかは大体入ってるだろう。
シェルでやらないのは遅くなるから。こういう処理は重いので変更入ったものだけにしてあげたい気持ち。

## 機能

指定したディレクトリ以下から.mdファイルを探してきてhtmlに変換するタスクを実行するよ。
実際のビルドは何か他のツールに任せてあげてね。

## 使い方

### MSBuild版

MSBuildはv4以上。なぜかというとプロパティ関数を使っているから。使える範囲広くしたいなぁ。

1. pandocへのパスを通す。
1. MSBuildへのパスを通す。面倒ならMSBuildSearcher.ps1とか実行する。場所は'C:\Windows\Microsoft.NET\Framework64\v4.0.30319'とかに入ってるはず。
1. cmdかpowershellを起動して、このファイルのディレクトリにcdする。
1. 'msbuild markdowns.proj -t:Artifact'って打つ。
1. 'markdown'ディレクトリ以下のmdファイルがhtmlに変換されて出てくる。インクリメンタルビルドするように実装してあるので2回たたいても安心。

### 制限

* markdownたちがプロジェクトファイルのディレクトリ以下に入っているのを期待してる感じです。

### 色々

* 色変えたい
    * markdown.css.htmlいじってね
* markdownディレクトリじゃなきゃダメ？
    * projファイルいじってね
* pdfにできない？
    * chromeへのパスを通してpdfartifactをターゲットにして実行してください。今のところインクリメンタルビルドじゃないので問題あり。
* pandocって？
    * mdをhtmlにしてくれるのに使うありがたいツール。Haskell製らしい：https://pandoc.org/
* pandocないと使えない？
    * 今のところは。ただここ変えたい。
* MSBuildは標準で入ってるから使うのにpandoc使うの？それ標準じゃないよね？
    * そうですね。

## 参考

example.htmlは以下のexample.htmlを使わせていただきました。
https://github.com/simonlc/Markdown-CSS