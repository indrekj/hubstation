module Fetchers ( fetchOperator, fetchVisitor ) where

import Models

fetchOperator :: Int -> Either String Operator
fetchOperator id =
  if id < 10 then
    Right $ Operator "John"
  else
    Left $ "Operator with id " ++ show id ++ " not found"

fetchVisitor :: Int -> Either String Visitor
fetchVisitor id = Right $ Visitor "Mary"
