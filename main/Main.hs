{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import FizzBuzz.FizzBuzz as FB
import DarkLaunch.Store as DS

import System.Environment (getArgs)

subCommand :: String -> IO ()
subCommand a
        | a == "darklaunch" = DS.getKeys
        | a == "fizzbuzz" = FB.fizzBuzz
        | otherwise = putStrLn "Unknown application"

main :: IO ()
main = do
    args <- getArgs
    if 1 <= length args
      then subCommand (args !! 0)
      else putStrLn "Arguments are too short"
