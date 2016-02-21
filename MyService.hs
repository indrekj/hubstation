module MyService (processMessage) where

import Control.Monad
import Fetchers (fetchVisitor, fetchOperator)
import Responses (Response (..), engagementCreatedResponse, sampleResponse, errorResponse)
import Requests (Request (..))
import Data.Aeson (ToJSON, FromJSON, encode, decode, eitherDecode)
import qualified Data.ByteString.Lazy.Char8 as BL

processMessage :: BL.ByteString -> BL.ByteString
processMessage rawRequest =
  case doIt rawRequest of
    Right response -> encode response
    Left error     -> encode $ errorResponse error

doIt rawRequest = do
  request <- eitherDecode rawRequest

  case request of
    EngagementCreateRequest {} -> createEngagement request
    SampleRequest {}           -> Right $ sampleResponse "teine"
    _                          -> Left "Unknown request"

createEngagement :: Request -> Either String Response
createEngagement request = do
  operator <- fetchOperator $ operator_id request
  visitor <- fetchVisitor $ visitor_id request

  Right $ engagementCreatedResponse operator visitor
