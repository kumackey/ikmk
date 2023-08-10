# ikmk

## 言語特徴

loopは再起

## モナドとは

よくわからなかったけど、アクションなどの結果がわからないものを抽象化してる
IO
Maybe(Result的なもの)
Either(Option的なもの)

http://guppy.eng.kagawa-u.ac.jp/2007/HaskellKyoto/Text/Chapter3.pdf

## 実行

```
cabal run ikmk fizzbuzz
cabal run ikmk darklaunch get
cabal run ikmk darklaunch post enable-aaa True
cabal run ikmk darklaunch get
```