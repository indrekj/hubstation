{-# LANGUAGE DeriveGeneric #-}
module Responses (Response (..), engagementCreatedResponse, sampleResponse, errorResponse) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON)
import Models

data Response =
  EngagementCreatedResponse {
    engagement_id :: Int,
    visitor_name :: String,
    operator_name :: String
  } |

  SampleResponse {
    message :: String
  } |

  ErrorResponse {
    message :: String
  }

  deriving (Generic, Show)

instance ToJSON Response

engagementCreatedResponse :: Operator -> Visitor -> Response
engagementCreatedResponse operator visitor =
  EngagementCreatedResponse {
    engagement_id = 5,
    visitor_name = visitorName visitor,
    operator_name = operatorName operator
  }

sampleResponse :: String -> Response
sampleResponse body =
  SampleResponse {
    message = body
  }

errorResponse :: String -> Response
errorResponse body =
  ErrorResponse {
    message = body
  }
