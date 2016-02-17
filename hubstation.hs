import Control.Monad
import Request (Request, fetch)
import SampleRequests (validRequest, fetchFailRequest, noKeyRequest)

data Operator = Operator {operatorName :: String} deriving (Show)
data Visitor  = Visitor  {visitorName :: String} deriving (Show)

fetchOperator :: Int -> Either String Operator
fetchOperator id =
  if id < 10 then
    Right $ Operator "John"
  else
    Left $ "Operator with id " ++ show id ++ " not found"

fetchVisitor :: Int -> Either String Visitor
fetchVisitor id = Right $ Visitor "Mary"

renderResponse :: Operator -> Visitor -> String
renderResponse operator visitor =
  "Found operator " ++ operatorName operator ++ " and visitor " ++ visitorName visitor

-- Tried to emulate substation like chain
createEngagement :: Request -> Either String String
createEngagement request = do
  operatorId <- fetch "operator_id" request
  visitorId <- fetch "visitor_id" request

  operator <- fetchOperator operatorId
  visitor <- fetchVisitor visitorId

  Right $ renderResponse operator visitor

-- sample usage:
-- createEngagement validRequest
-- createEngagement fetchFailRequest
-- createEngagement noKeyRequest
