module Main (main) where

import FizzBuzz.FizzBuzz as FB
import DarkLaunch.Store as DS

import System.Environment (getArgs)

subCommand :: [String] -> IO ()
subCommand args
        | args !! 0 == "darklaunch" = do
            case args !! 1 of
             "get" -> DS.getKeys
             "post" -> DS.postKey (args !! 2) (args !! 3)
             _ -> putStrLn $ "invalid method: " ++ args !! 1
        | args !! 0 == "fizzbuzz" = FB.fizzBuzz
        | otherwise = putStrLn "Unknown application"

main :: IO ()
main = do
    args <- getArgs
    if 1 <= length args
      then subCommand args
      else putStrLn "Arguments are too short"
