{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Hdump (app)
import Test.Hspec

import Test.Hspec.Wai
import Test.Hspec.Wai.JSON

main :: IO ()
main = hspec spec

spec :: Spec
spec =
  describe "nothing" $ do
    it "be true" $ do
      True `shouldBe` True
