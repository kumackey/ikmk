{-# LANGUAGE OverloadedStrings #-}
module DarkLaunch.Store where

import qualified Data.ByteString.Lazy as BL
import Data.Csv as CSV
import Data.Csv.Builder
import qualified Data.Vector as V
import qualified Data.HashMap.Strict as HM

data Key = Key
    { name   :: String
    , variations :: Bool
    } deriving Show

data KeyRecord = KeyRecord
                     { recordName   :: !String
                     , recordVariations :: !String
                     } deriving (Show, Eq)

instance CSV.ToNamedRecord KeyRecord where
    toNamedRecord (KeyRecord recordName recordVariations) = namedRecord [
            "name" .= recordName, "variations" .= recordVariations]
--    toRecord (KeyRecord recordName' recordVariations') = record [
--        toField recordName', toField recordVariations']

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

convKeyToKeyRecord :: Key -> KeyRecord
convKeyToKeyRecord key = do
    let v = (convBoolToString .variations) key
    KeyRecord (name key) v

instance CSV.FromNamedRecord KeyRecord where
    parseNamedRecord r = KeyRecord <$> r .: "name" <*> r .: "variations"

findAllKeys :: IO (HM.HashMap String Key)
findAllKeys = do
  csvData <- BL.readFile "src/DarkLaunch/keys.csv"
  case decodeByName csvData of
      Left err -> do
          putStrLn err
          return HM.empty
      Right (_, v) -> do
          let keys = [k | Just k <- map convKeyRecordToKey $ V.toList v]
          return $ HM.fromList $ map (\k -> (name k, k)) keys

getKeys :: IO()
getKeys = do
    keys <- findAllKeys
    print keys

convBoolToString :: Bool -> String
convBoolToString bool
                   | bool  = "True"
                   | otherwise = "False"

postKey :: String -> Bool ->  IO()
postKey key variations = do
  ks <- findAllKeys
  let krs = map (\k -> convKeyToKeyRecord k) (HM.elems ks)
  let keys = KeyRecord key (convBoolToString variations) : krs
  BL.writeFile "src/DarkLaunch/keys.csv" $ encodeByName (header["name", "variations"]) keys
  putStrLn "added"
