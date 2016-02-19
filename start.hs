{-# OPTIONS -XOverloadedStrings #-}

import qualified Freddy
import Responses.SampleResponse

processMessage :: String -> SampleResponse
processMessage x = sampleResponse "hehe"

main = do
  fConnection <- Freddy.connect "127.0.0.1" "/" "guest" "guest"

  Freddy.respondTo fConnection "haskell" processMessage

  putStrLn "Service started"
