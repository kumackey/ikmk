loop 101 action = return ()
loop n action = do { action n; loop (n + 1) action }

fizzbuzz :: Int -> String
fizzbuzz n
  | n `mod` 15 == 0 = "Fizzbuzz"
  | n `mod` 5 == 0 = "Buzz"
  | n `mod` 3 == 0 = "Fizz"
  | otherwise = show n
main = loop 1 $ (putStrLn . fizzbuzz)