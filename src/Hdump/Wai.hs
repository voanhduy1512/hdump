module Hdump.Wai (getRequestBody) where

import Network.Wai
import qualified Data.ByteString.Char8 as S8

getRequestBody :: Request -> IO S8.ByteString
getRequestBody req = do
  let loop front = do
         bs <- requestBody req
         if S8.null bs
             then return $ front []
             else loop ( front . (bs:) )
  body <- loop id
  return (mconcat body)
