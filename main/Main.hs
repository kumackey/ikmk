{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import FizzBuzz.FizzBuzz

import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types (status200)
import Blaze.ByteString.Builder (copyByteString)
import qualified Data.ByteString.UTF8 as BU
import Data.Monoid
import Control.Applicative
import qualified Data.ByteString.Lazy as BL
import Data.Csv
import qualified Data.Vector as V
import System.Environment (getArgs)
--
----main = do
----    run 8000 app
----
----app req respond = respond $
----    case pathInfo req of
----        x -> index x
----
----
----
----index x = responseBuilder status200 [("Content-Type", "application/json")] $ mconcat (map copyByteString [ "hello" ])
--
----main :: IO()
----main = do
----    let foo = Foo 1 "hello"
----    (putStrLn . show) foo
----
----data Foo = Foo { id :: Int, content :: String } deriving Show
----
----instance ToJSON Foo where
----  toJSON (Foo id content) = object [ "id" .= id,
----                                     "content" .= content ]
--
convStringToBool :: String -> Maybe Bool
convStringToBool str
                   | str == "True" = Just True
                   | str == "False" = Just False
                   | otherwise = Nothing

convKeyRecordToKey :: KeyRecord -> Maybe Key
convKeyRecordToKey record = do
    let rec = (convStringToBool .recordVariations) record
    case rec of
        Just r -> Just (Key (recordName record) r)
        Nothing -> Nothing

data Key = Key
    { name   :: String
    , variations :: Bool
    }

data KeyRecord = KeyRecord
                     { recordName   :: !String
                     , recordVariations :: !String
                     }
instance FromNamedRecord KeyRecord where
    parseNamedRecord r = KeyRecord <$> r .: "name" <*> r .: "variations"

subCommand :: String -> IO ()
subCommand a
        | a == "darklaunch" = do
            csvData <- BL.readFile "keys.csv"
            case decodeByName csvData of
                Left err -> putStrLn err
                Right (_, v) -> V.forM_ v $ \ k -> do
                    let km = convKeyRecordToKey(k)
                    case km of
                        Just km -> putStrLn $ "Key Name: " ++ name km ++ ", Variations: " ++ show (variations km)
                        Nothing -> putStrLn "invalid"
        | a == "fizzbuzz" = loop 100 $ (putStrLn . fizzbuzz)
        | otherwise = putStrLn "Unknown application"

main :: IO ()
main = do
    args <- getArgs
    if 1 <= length args
      then subCommand (args !! 0)
      else putStrLn "Arguments are too short"
