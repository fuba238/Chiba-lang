# Chiba-lang(仮称)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [コンセプト](#コンセプト)
  - [概要](#概要)
  - [記述例](#記述例)
- [データ型](#データ型)
  - [数値型](#数値型) 
- [](#)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## コンセプト
### 概要
　Chiba-langは，Scratchからテキストプログラミング言語への移行時の差異の大きさを軽減することを目的としたプログラミング言語です．小学校でScratchを利用したプログラミング学習を行なった次の段階で使用されることを想定している．以下に，Chiba-langのコンセプトをまとめる．
 1. Scratchのようにスプライトを動かすことで，プログラミングを行う．
 2. 中学生が使うことを想定し，中学生でもわかりやすい英単語を使用する．
 3. ソースコードを見返したとき，上から下，左から右へと処理の流れがわかりやすい文法にする．
 4. C言語のinclude文のような「おまじない」と呼ばれるような要素を作らない．
 5. Scratchと同様に，Webブラウザ上での動作を想定する．
### 記述例
```vb
Splite.new -> cat;
(1~10).each (i) => {
  cat.x + i |> cat.x;
}
```
1行目の<font color="red">Splite.new -> cat;</font>では，スプライトの生成を行なっています．例ではcatという変数名のスプライトを生成しています．

2行目の<font color="red">(1~10).each</font>は，each文で繰り返し処理を表しています．例では10回繰り返し処理を行います．

2行目から4行目の<font color="red">(i) => { cat.x + i |> cat.x }</font>は，ラムダ式でeach文で繰り返す処理を記述しています，例では，cat.xはスプライトのx軸の値を表しており，x軸の値にiを加算する処理を10回行います．
## データ型
### 数値型
