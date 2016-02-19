{-# LANGUAGE DeriveGeneric #-}
module Requests.SampleRequest ( SampleRequest ) where

import GHC.Generics (Generic)
import Data.Aeson (FromJSON)

data SampleRequest = SampleRequest {
  message :: String
} deriving (Generic, Show)

instance FromJSON SampleRequest
