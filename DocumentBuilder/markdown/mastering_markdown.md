Mastering-markdown-jp
======

## 訳にあたって

翻訳元：https://guides.github.com/features/mastering-markdown/
結構端折ってます。

Markdown は軽くて簡単に使える言語です。GitHubプラットフォームで文章を記述するために使用できます。

**何が身につくか**

- どのようにMarkdownを利用するか
- Markdownはこれまでのものとどう違うか。
- GitHubのMarkdown自動レンダリングの活用
- GitHubの独自拡張をどう利用するか 

## Markdownってなに？

MarkdownはWebで文章を書くための方法です。ドキュメントの表示を取り扱います。
つまり、太字や斜体、画像の追加、リストの作成を簡単に行えます。
\#や\*を除き、Markdownはほとんど文章そのままです。

GitHubの多くの場所でMarkdownを使うことができます。

* Gists
* イシュー、プルリクエストのコメント
* .md、.markdown形式のファイル

もっと知りたい場合は、GitHubヘルプ内の「GitHubで書く」をご覧ください。


## 文法ガイド

この章では、Markdown文法についての概要です。これらはGitHub.comやテキストファイルで使用できます。

### 見出し（Headers）

```
# これは<h1>タグになります
## これは<h2>タグになります
####### これは<h6>タグです
```

### 強調（Emphasis）

```
*このテキストは斜体になります*
_このテキストも斜体になります_

**これは太字になります**
__これも太字になります__


_これらを **あわせて** 使うこともできます_
```


### リスト（Lists）

#### 順序なし

```
* 項目 1
* 項目 2
    * 項目 2a
    * 項目 2b
```

### 順序あり

```
1. 項目 1
1. 項目2
1. 項目 3
    1. 項目 3a
    1. 項目 3b
```

### 画像（Images）

```
![GitHubロゴ](/images/logo.png)
形式: ![Alt Text](url
```

### リンク（Links）

```
http://github.com - 自動でリンクされます！
[GitHub](http://github.com)
```

### 引用（Blockquotes）

``` 
カニエ・ウェストは言った：

> 我々は未来を生きている。
> 今とは過去なのだ。
```

