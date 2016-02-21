{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module Requests (Request (..)) where

import GHC.Generics (Generic)
import Data.Aeson ((.:), FromJSON, parseJSON, withObject)

data Request =
  SampleRequest {
    message :: String
  } |

  EngagementCreateRequest {
    operator_id :: Int,
    visitor_id  :: Int
  }

  deriving (Generic, Show)

instance FromJSON Request where
  parseJSON = withObject "request" $ \o -> do
    kind <- o .: "type"
    mkReq kind o

mkReq "create_engagement" o =
  EngagementCreateRequest <$> o .: "operator_id" <*> o .: "visitor_id"

mkReq "sample_request" o = SampleRequest <$> o .: "message"
mkReq kind o = fail ("unknown kind: " ++ kind)
