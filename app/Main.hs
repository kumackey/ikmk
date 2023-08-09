{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative
import qualified Data.ByteString.Lazy as BL
import Data.Csv
import qualified Data.Vector as V

convStringToBool :: String -> Bool
convStringToBool str
                   | str == "True" = True
                   | otherwise = False

convKeyRecordToKey :: KeyRecord -> Key
convKeyRecordToKey record =
    Key (recordName record) ((convStringToBool .recordVariations) record)

data Key = Key
    { name   :: !String
    , variations :: !Bool
    }

data KeyRecord = KeyRecord
                     { recordName   :: !String
                     , recordVariations :: !String
                     }

instance FromNamedRecord KeyRecord where
    parseNamedRecord r = KeyRecord <$> r .: "name" <*> r .: "variations"

main :: IO ()
main = do
    csvData <- BL.readFile "keys"
    case decodeByName csvData of
        Left err -> putStrLn err
        Right (_, v) -> V.forM_ v $ \ k -> do
            let key = convKeyRecordToKey(k)
            putStrLn $ "Key Name: " ++ name key ++ ", Variations: " ++ show (variations key)