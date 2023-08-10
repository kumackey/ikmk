{-# LANGUAGE OverloadedStrings #-}
module DarkLaunch.Store where

import Data.Csv as CSV
import Data.Csv.Builder
import Data.Time.Clock
import Data.Time.ISO8601
import qualified Data.ByteString.Lazy as BL
import qualified Data.HashMap.Strict as HM
import qualified Data.Vector as V


data Key = Key
    { name   :: String
    , variations :: Bool
    , updateAt :: UTCTime
    } deriving Show

data KeyRecord = KeyRecord
                     { recordName   :: !String
                     , recordVariations :: !String
                     , recordUpdatedAt :: !String
                     } deriving (Show, Eq)

instance CSV.FromNamedRecord KeyRecord where
    parseNamedRecord r = KeyRecord <$> r .: "name" <*> r .: "variations" <*> r .: "updated_at"

instance CSV.ToNamedRecord KeyRecord where
    toNamedRecord (KeyRecord recordName recordVariations recordUpdatedAt) = namedRecord [
            "name" .= recordName, "variations" .= recordVariations, "updated_at" .= recordUpdatedAt]

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
    case (parseISO8601 . recordUpdatedAt) record of
        Just time -> do
            case (convStringToBool .recordVariations) record of
                Just r -> Just (Key (recordName record) r time)
                Nothing -> Nothing
        Nothing -> Nothing

convKeyToKeyRecord :: Key -> KeyRecord
convKeyToKeyRecord key = do
    let v = (convBoolToString .variations) key
    KeyRecord (name key) v ((formatISO8601.updateAt) key)

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
      time <- getCurrentTime
      let keys = KeyRecord key variations (formatISO8601 time) : krs
      BL.writeFile "src/DarkLaunch/keys.csv" $ encodeByName (header["name", "variations", "updated_at"]) keys
      putStrLn "added"

