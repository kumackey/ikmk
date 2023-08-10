module Main (main) where

import FizzBuzz.FizzBuzz as FB
import DarkLaunch.Store as DS

import System.Environment (getArgs)

subCommand :: [String] -> IO ()
subCommand args
        | args !! 0 == "darklaunch" = do
            if args !! 1 == "post"
                then DS.postKey (args !! 2) (args !! 3)
                else putStrLn "Arguments are too short, post"
        | args !! 0 == "fizzbuzz" = FB.fizzBuzz
        | otherwise = putStrLn "Unknown application"

main :: IO ()
main = do
    args <- getArgs
    if 1 <= length args
      then subCommand args
      else putStrLn "Arguments are too short"
