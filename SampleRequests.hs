module SampleRequests ( validRequest, fetchFailRequest, noKeyRequest ) where

import qualified Data.Map.Strict as Map
import Request (Request)

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
