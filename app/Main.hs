module Main where

import System.Environment
import Text.Read
import Hdump

main :: IO ()
main = do
  port <- getPort
  case port of
    Left a -> print a
    Right p -> startApp p

getPort :: IO (Either String Int)
getPort = do
  port <- getEnv "HDUMP_PORT"
  return $ readEither port
