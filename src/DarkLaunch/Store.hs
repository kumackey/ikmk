{-# LANGUAGE OverloadedStrings #-}
module DarkLaunch.Store where

import Data.Csv as CSV
import Data.Csv.Builder
import qualified Data.ByteString.Lazy as BL
import qualified Data.HashMap.Strict as HM
import qualified Data.Vector as V

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

convStringToBool :: String -> Maybe Bool
convStringToBool str
                   | str == "True" = Just True
                   | str == "False" = Just False
                   | otherwise = Nothing

convBoolToString :: Bool -> String
convBoolToString bool
                   | bool  = "True"
                   | otherwise = "False"

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

postKey :: String -> String ->  IO()
postKey key variations = do
  ks <- findAllKeys
  if HM.member key ks
    then putStrLn $ "key already exists: " ++ key
    else do
      let krs = map (\k -> convKeyToKeyRecord k) (HM.elems ks)
      let keys = KeyRecord key variations : krs
      BL.writeFile "src/DarkLaunch/keys.csv" $ encodeByName (header["name", "variations"]) keys
      putStrLn "added"

