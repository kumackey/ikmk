{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Network.Wai.Handler.Warp as Warp
import qualified Network.Wai as Wai
import qualified Network.HTTP.Types as HTypes

main :: IO ()
main = Warp.run 8000 helloApp

helloApp :: Wai.Application
helloApp req send = send $ Wai.responseBuilder HTypes.status200 [] "hello wai"