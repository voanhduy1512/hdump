module Hdump.Types where

import Network.Wai
import qualified Data.ByteString.Char8 as S8

type RequestStore = (Request, S8.ByteString)
