{-# LANGUAGE OverloadedStrings #-}
module DarkLaunch.Store where

import qualified Data.ByteString.Lazy as BL
import Data.Csv as CSV
import qualified Data.Vector as V

data Key = Key
    { name   :: String
    , variations :: Bool
    } deriving Show

data KeyRecord = KeyRecord
                     { recordName   :: !String
                     , recordVariations :: !String
                     }

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

instance CSV.FromNamedRecord KeyRecord where
    parseNamedRecord r = KeyRecord <$> r .: "name" <*> r .: "variations"

--gKeys :: [KeyRecord]
--gKeys = do
--    csvData <- BL.readFile "src/DarkLaunch/keys.csv"
--    case decodeByName csvData of
--                    Left err -> []
--                    Right (_, v) -> V.toList v
getKeys :: IO [Key]
getKeys = do
    csvData <- BL.readFile "src/DarkLaunch/keys.csv"
    case decodeByName csvData of
        Left err -> do
            putStrLn err
            return []
        Right (_, v) -> do
            let keys = [k | Just k <- map convKeyRecordToKey $ V.toList v]
            return keys