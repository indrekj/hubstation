module Models ( Operator (..), Visitor (..) ) where

data Operator = Operator {operatorName :: String} deriving (Show)
data Visitor  = Visitor  {visitorName :: String} deriving (Show)
