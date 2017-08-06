{-# LANGUAGE OverloadedStrings #-}

module Hdump.Json (toJson) where

import Data.CaseInsensitive (original)
import Data.Aeson
import Data.Monoid                        ((<>))
import Data.Text.Encoding (decodeUtf8)
import Network.HTTP.Types
import Network.Wai
import qualified Data.ByteString.Char8 as S8
import qualified Data.Text as T
import Hdump.Types

toJson :: [RequestStore] -> [Value]
toJson = fmap $ uncurry requestToJSON

requestToJSON :: Request -> S8.ByteString -> Value
requestToJSON req body = object [ "method" .= decodeUtf8 (requestMethod req)
                          , "path" .= decodeUtf8 (rawPathInfo req)
                          , "queryString" .= map queryItemToJSON (queryString req)
                          , "httpVersion" .= httpVersionToJSON (httpVersion req)
                          , "headers" .= requestHeadersToJSON (requestHeaders req)
                          , "size" .= requestBodyLengthToJSON (requestBodyLength req)
                          , "body" .= decodeUtf8 body
                          ]

queryItemToJSON :: QueryItem -> Value
queryItemToJSON (name, mValue) = toJSON (decodeUtf8 name, fmap decodeUtf8 mValue)

httpVersionToJSON :: HttpVersion -> Value
httpVersionToJSON (HttpVersion major minor) = String $ T.pack (show major) <> "." <> T.pack (show minor)

requestHeadersToJSON :: RequestHeaders -> Value
requestHeadersToJSON = toJSON . map hToJ where
  hToJ ("Cookie", _) = toJSON ("Cookie" :: T.Text, "-RDCT-" :: T.Text)
  hToJ hd = headerToJSON hd

headerToJSON :: Header -> Value
headerToJSON (headerName, header) = toJSON (decodeUtf8 . original $ headerName, decodeUtf8 header)

requestBodyLengthToJSON :: RequestBodyLength -> Value
requestBodyLengthToJSON ChunkedBody = String "Unknown"
requestBodyLengthToJSON (KnownLength l) = toJSON l

