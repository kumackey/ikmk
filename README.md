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

cabal run ikmk

## Fizzbuzz

```
ubuntu@ip-172-31-0-211:~/ikmk$ ghc FizzBuzz.hs 
[1 of 1] Compiling Main             ( FizzBuzz.hs, FizzBuzz.o )
Linking FizzBuzz ...
ubuntu@ip-172-31-0-211:~/ikmk$ ./FizzBuzz 
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
Fizzbuzz
16
17
Fizz
19
Buzz
Fizz
22
23
Fizz
Buzz
26
Fizz
28
29
Fizzbuzz
31
32
Fizz
34
Buzz
Fizz
37
38
Fizz
Buzz
41
Fizz
43
44
Fizzbuzz
46
47
Fizz
49
Buzz
Fizz
52
53
Fizz
Buzz
56
Fizz
58
59
Fizzbuzz
61
62
Fizz
64
Buzz
Fizz
67
68
Fizz
Buzz
71
Fizz
73
74
Fizzbuzz
76
77
Fizz
79
Buzz
Fizz
82
83
Fizz
Buzz
86
Fizz
88
89
Fizzbuzz
91
92
Fizz
94
Buzz
Fizz
97
98
Fizz
Buzz
```