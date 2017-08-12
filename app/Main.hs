module Main where

import System.Environment
import Text.Read
import Hdump
import Options.Applicative
import Data.Monoid ((<>))

data CommandLineOptions = CommandLineOptions {
    port :: Int
}

commandLineOptions :: Parser CommandLineOptions
commandLineOptions = CommandLineOptions <$> option auto
                      ( long "port"
                      <> short 'p'
                      <> metavar "PORT"
                      <> value (3000 :: Int)
                      <> help "Port that application will listen on")

main :: IO ()
main = do
    opt <- execParser opts
    portString' <- (readMaybe =<<) <$> lookupEnv "HDUMP_PORT"
    startApp $ getPort portString' $ port opt
  where
    opts = info (helper <*> commandLineOptions)
      ( fullDesc
      <> progDesc "Simple server that captures all requests to it"
      <> header "Hdump - make it easy to debug your api requests")

getPort :: Maybe Int -> Int -> Int
getPort (Just p) _ = p
getPort Nothing p = p
