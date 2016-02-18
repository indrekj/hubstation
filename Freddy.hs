{-# OPTIONS -XOverloadedStrings #-}
module Freddy (respondTo) where

import Network.AMQP
import qualified Data.ByteString.Lazy.Char8 as BL

-- TODO queueName as an argument, need to change String to Text
respondTo :: t -> (Channel -> (Message, Envelope) -> IO ()) -> IO ()
respondTo queueName callback = do
  conn <- openConnection "127.0.0.1" "/" "guest" "guest"
  chan <- openChannel conn

  declareQueue chan newQueue {queueName = "haskell"}

  consumeMsgs chan "haskell" NoAck (callback chan)

  getLine -- wait for keypress
  closeConnection conn
  putStrLn "connection closed"

--sendReply :: Channel -> Data.Text.Internal.Text -> Message -> IO ()
sendReply channel queueName msg = do
  let reply = newMsg {msgBody = (BL.pack "{\"it\": \"works\"}"),
                      msgCorrelationID = (msgCorrelationID msg),
                      msgDeliveryMode = Just NonPersistent}
  publishMsg channel "" queueName reply
  putStrLn $ "Sent message: " ++ (show reply)

sampleCallback :: Channel -> (Message, Envelope) -> IO ()
sampleCallback channel (msg, env) = do
  putStrLn $ "Received message: " ++ (show msg)

  case msgReplyTo msg of
    Just queueName -> sendReply channel queueName msg
    Nothing -> putStrLn $ "Could not reply"
