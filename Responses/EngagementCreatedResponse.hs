{-# LANGUAGE DeriveGeneric #-}
module Responses.EngagementCreatedResponse ( engagementCreatedResponse, EngagementCreatedResponse ) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON)
import Models

data EngagementCreatedResponse = EngagementCreatedResponse {
  engagement_id :: Int,
  visitor_name :: String,
  operator_name :: String
} deriving (Generic, Show)

instance ToJSON EngagementCreatedResponse

engagementCreatedResponse :: Operator -> Visitor -> EngagementCreatedResponse
engagementCreatedResponse operator visitor =
  EngagementCreatedResponse {
    engagement_id = 5,
    visitor_name = visitorName visitor,
    operator_name = operatorName operator
  }
