{-# LANGUAGE DeriveGeneric #-}
module Responses.SampleResponse ( sampleResponse ) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, toEncoding, defaultOptions, genericToEncoding)

data SampleResponse = SampleResponse {
  message :: String
} deriving (Generic, Show)

instance ToJSON SampleResponse where
  toEncoding = genericToEncoding defaultOptions

sampleResponse :: String -> SampleResponse
sampleResponse body =
  SampleResponse {
    message = body
  }
