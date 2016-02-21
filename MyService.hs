module MyService (processMessage) where

import Control.Monad
import Fetchers (fetchVisitor, fetchOperator)
import Responses.EngagementCreatedResponse (engagementCreatedResponse, EngagementCreatedResponse)
import Models

import Requests (Request (..))
import Responses.SampleResponse
import Data.Aeson (ToJSON, FromJSON, encode, decode, eitherDecode)
import qualified Data.ByteString.Lazy.Char8 as BL

processMessage :: BL.ByteString -> BL.ByteString
processMessage rawRequest =
  case (eitherDecode rawRequest :: Either String Request) of
    Right request -> case request of
      EngagementCreateRequest _ _ -> encode $ createEngagement request
      SampleRequest _             -> encode $ sampleResponse "teine"
    Left m  -> encode $ sampleResponse m

createEngagementPure :: EngagementCreatedResponse
createEngagementPure = engagementCreatedResponse (Operator "op") (Visitor "vs")

-- Tried to emulate substation like chain
--
-- sample usage:
--   freddy.deliver_with_response 'haskell', operator_id: 4, visitor_id: 6, type: "create_engagement"
createEngagement :: Request -> Either String EngagementCreatedResponse
createEngagement request = do
  operator <- fetchOperator $ operator_id request
  visitor <- fetchVisitor $ visitor_id request

  Right $ engagementCreatedResponse operator visitor
