{-# LANGUAGE DeriveGeneric #-}
module Responses.EngagementCreatedResponse ( engagementCreatedResponse, EngagementCreatedResponse ) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON)
import Models

data EngagementCreatedResponse = EngagementCreatedResponse {
  message :: String
} deriving (Generic, Show)

instance ToJSON EngagementCreatedResponse

engagementCreatedResponse :: Operator -> Visitor -> EngagementCreatedResponse
engagementCreatedResponse operator visitor =
  EngagementCreatedResponse {
    message = "Engagement created for operator "
      ++ operatorName operator
      ++ " and visitor "
      ++ visitorName visitor
  }
