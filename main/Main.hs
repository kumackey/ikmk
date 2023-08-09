{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import FizzBuzz.FizzBuzz as FB
import DarkLaunch.Store

import Blaze.ByteString.Builder (copyByteString)
import qualified Data.ByteString.Lazy as BL
import Data.Csv
import qualified Data.Vector as V
import System.Environment (getArgs)

instance FromNamedRecord KeyRecord where
    parseNamedRecord r = KeyRecord <$> r .: "name" <*> r .: "variations"

subCommand :: String -> IO ()
subCommand a
        | a == "darklaunch" = do
            csvData <- BL.readFile "src/DarkLaunch/keys.csv"
            case decodeByName csvData of
                Left err -> putStrLn err
                Right (_, v) -> V.forM_ v $ \ k -> do
                    let km = convKeyRecordToKey(k)
                    case km of
                        Just km -> putStrLn $ "Key Name: " ++ name km ++ ", Variations: " ++ show (variations km)
                        Nothing -> putStrLn "invalid"
        | a == "fizzbuzz" = FB.fizzBuzz
        | otherwise = putStrLn "Unknown application"

main :: IO ()
main = do
    args <- getArgs
    if 1 <= length args
      then subCommand (args !! 0)
      else putStrLn "Arguments are too short"
