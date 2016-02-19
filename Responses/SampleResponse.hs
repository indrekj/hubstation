{-# LANGUAGE DeriveGeneric #-}
module Responses.SampleResponse ( sampleResponse, SampleResponse ) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON)

data SampleResponse = SampleResponse {
  message :: String
} deriving (Generic, Show)

instance ToJSON SampleResponse

sampleResponse :: String -> SampleResponse
sampleResponse body =
  SampleResponse {
    message = body
  }
