# 出来らあっ！HaskellでDarkLuanchを作れるっていったんだよ!!

## 実行

```
cabal run ikmk fizzbuzz
cabal run ikmk darklaunch get
cabal run ikmk darklaunch post enable-aaa True
cabal run ikmk darklaunch get
```

え！！HaskellでDarkLuanchを？

## 言語特徴

### loopは再起

0からindexを取っていくのが逆に大変？

```haskell
loop 0 action = return ()
loop n action = do { action (100 - n + 1); loop (n - 1) action }
```

### 関数の合成

f(g(x))はg(x)を実行してからf(...)を実行するのではなく、f.gを合成する

```haskell
KeyRecord (name key) v ((formatISO8601.updateAt) key)
-- 以下と同義だが、上の方がたぶんhaskellっぽい
-- KeyRecord (name key) v (formatISO8601(updateAt(key)))
```

### classとinstance

いわゆるclassとinstanceではない 
classはインタフェースに近く、任意の型を定義できる
instanceで型に合う実装を行う
```haskell
-- https://hackage.haskell.org/package/cassava-0.5.3.0/docs/src/Data.Csv.Conversion.html#FromNamedRecord
class FromNamedRecord a where
    parseNamedRecord :: NamedRecord -> Parser a

    default parseNamedRecord :: (Generic a, GFromNamedRecord (Rep a)) => NamedRecord -> Parser a
    parseNamedRecord = genericParseNamedRecord defaultOptions

-- 本アプリケーション側
instance CSV.FromNamedRecord KeyRecord where
    parseNamedRecord r = KeyRecord <$> r .: "name" <*> r .: "variations" <*> r .: "updated_at"
```

### パターンマッチ

失敗ケース/成功ケースを型として定義・ハンドリングできる仕組み

```haskell
  case decodeByName csvData of
      Left err -> do
          putStrLn err
          return HM.empty
      Right (_, v) -> do
          let keys = [k | Just k <- map convKeyRecordToKey $ V.toList v]
          return $ HM.fromList $ map (\k -> (name k, k)) keys
```

### モナド(逆に教えてください🥲)

よくわからなかったけど、アクションなどの結果がわからないものを抽象化してる
IO
Maybe(Option的なもの)
Either(Result的なもの)

http://guppy.eng.kagawa-u.ac.jp/2007/HaskellKyoto/Text/Chapter3.pdf

## 感想

想像の10倍むずかった