# Chiba-lang

## コンセプト
プログラミング教育の必修化により，小学校ではScratchを代表とするビジュアルプログラミング言語を活用する事例が増え始めている．しかし，本格的にプログラミングを学習していく上でテキストプログラミング言語への移行が必要となる．そこで，Scratchとテキストプログラミング言語の仕様の違いを軽減したプログラミング言語「Chiba-lang」を開発する．

- ブラウザ上での動作を想定
- 実行環境には，Scratchと同様にステージやスプライトの機能を有する
- 中学までで習う英単語や日常的に使用される英単語で構成（ScratchやStage,EventなどScratchに類する機能の英単語は妥協している）
- 上から下，左から右へと視覚的にわかりやすい書式
- ~~シンプルな記述方法~~→構文解析の都合上，現時点ではタイピング素人には，少し難易度が高いようになっているかも？
- C言語におけるinclude文のようなおまじない要素は作らない

## ファイルの説明
### [Language](https://github.com/fuba238/Chiba-lang/tree/main/Language)
言語仕様やメソッド一覧をまとめている


### [grammer](https://github.com/fuba238/Chiba-lang/tree/main/grammer)
~~文法について記述している~~あんまり更新していない

### [pegjs](https://github.com/fuba238/Chiba-lang/tree/main/pegjs)
構文解析器を開発していた，test.pegjsが一番進んでるけど中途半端

### [samples](https://github.com/fuba238/Chiba-lang/tree/main/samples)
本言語を使用したときのサンプルプログラムを作った
主にScratchと類似した機能
