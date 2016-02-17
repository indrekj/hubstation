module Request ( Request, fetch ) where

import qualified Data.Map.Strict as Map

type Request  = Map.Map String Int

fetch :: String -> Request -> Either String Int
fetch key request = case Map.lookup key request of
  Just value -> Right value
  Nothing -> Left $ "Key " ++ key ++ " not found"

