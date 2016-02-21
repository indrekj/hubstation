{-# OPTIONS -XOverloadedStrings #-}

import qualified Freddy
import MyService (processMessage)

main = do
  fConnection <- Freddy.connect "127.0.0.1" "/" "guest" "guest"

  Freddy.respondTo fConnection "haskell" processMessage

  putStrLn "Service started!"
  putStrLn ""
  putStrLn "Sample usage:"
  putStrLn "  freddy.deliver_with_response 'haskell', operator_id: 4, visitor_id: 6, type: 'create_engagement'"
  putStrLn ""
