

postKey keyName variations :: String -> Bool -> Bool


-- variation
-- get /keys
-- post /keys


import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types (status200)

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