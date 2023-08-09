module DarkLaunch.Store where

data Key = Key
    { name   :: String
    , variations :: Bool
    }

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