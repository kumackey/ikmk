module FizzBuzz.FizzBuzz where

loop 0 action = return ()
loop n action = do { action (100 - n + 1); loop (n - 1) action }

printFizzBuzz :: Int -> String
printFizzBuzz n
  | n `mod` 15 == 0 = "Fizzbuzz"
  | n `mod` 5 == 0 = "Buzz"
  | n `mod` 3 == 0 = "Fizz"
  | otherwise = show n

fizzBuzz :: IO()
fizzBuzz = loop 100 $ (putStrLn . printFizzBuzz)