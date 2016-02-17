import Control.Monad
import qualified Data.Map.Strict as Map

data Operator = Operator {operatorName :: String} deriving (Show)
data Visitor  = Visitor  {visitorName :: String} deriving (Show)
type Request  = Map.Map String Int

validRequest :: Request
validRequest =
  Map.insert "operator_id" 5 .
  Map.insert "visitor_id"  4 $ Map.empty

fetchFailRequest :: Request
fetchFailRequest =
  Map.insert "operator_id" 15 .
  Map.insert "visitor_id"  4 $ Map.empty

noKeyRequest :: Request
noKeyRequest =
  Map.insert "visitor_id"  4 $ Map.empty



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

fetch :: String -> Request -> Either String Int
fetch key request = case Map.lookup key request of
  Just value -> Right value
  Nothing -> Left $ "Key " ++ key ++ " not found"


-- Tried to emulate substation like chain
createEngagement :: Request -> Either String String
createEngagement request = do
  operatorId <- fetch "operator_id" request
  visitorId <- fetch "visitor_id" request

  operator <- fetchOperator operatorId
  visitor <- fetchVisitor 4

  Right $ renderResponse operator visitor


-- sample usage:
-- createEngagement validRequest
-- createEngagement fetchFailRequest
-- createEngagement noKeyRequest
