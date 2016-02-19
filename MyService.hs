module MyService where

import Control.Monad
import Request (Request, fetch)
import SampleRequests (validRequest, fetchFailRequest, noKeyRequest)
import Fetchers (fetchVisitor, fetchOperator)
import Responses.EngagementCreatedResponse (engagementCreatedResponse, EngagementCreatedResponse)

-- Tried to emulate substation like chain
--
-- sample usage:
-- createEngagement validRequest
-- createEngagement fetchFailRequest
-- createEngagement noKeyRequest
--
createEngagement :: Request -> Either String EngagementCreatedResponse
createEngagement request = do
  operatorId <- fetch "operator_id" request
  visitorId <- fetch "visitor_id" request

  operator <- fetchOperator operatorId
  visitor <- fetchVisitor visitorId

  Right $ engagementCreatedResponse operator visitor
