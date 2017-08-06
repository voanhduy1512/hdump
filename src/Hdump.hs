{-# LANGUAGE OverloadedStrings #-}

module Hdump (app, startApp) where

import Blaze.ByteString.Builder           (fromByteString)
import Blaze.ByteString.Builder.Char.Utf8 (fromShow)
import Control.Concurrent.MVar
import Data.Aeson
import Data.Monoid                        ((<>))
import Network.HTTP.Types
import Network.Wai
import Hdump.Types
import Hdump.Json
import Hdump.Wai

import Network.Wai.Handler.Warp           (run, Port)
import Network.Wai.Middleware.Gzip (gzip, def)

startApp :: Port -> IO ()
startApp port = do
    storedRequests <- newMVar []
    run port $ gzip def $ app storedRequests

app :: MVar [RequestStore] -> Application
app storedRequests request
  | pathInfo request == ["admin"] = render storedRequests request
  | otherwise = store storedRequests request

render :: MVar [RequestStore] -> Application
render rs _req res = do
      requests <- readMVar rs
      res $ responseLBS
          status200
          [("Content-Type", "application/json")]
          $ encode $ toJson requests

store :: MVar [RequestStore] -> Application
store storedRequests request respond =
    modifyMVar storedRequests $ \requests -> do
        bs <- getRequestBody request
        let requests' = (request,bs):requests
            msg = fromByteString "Number of requests: " <> fromShow (length requests')
        responseReceived <- respond $ responseBuilder
            status200
            [("Content-Type", "text/plain")]
            msg
        return (requests', responseReceived)
