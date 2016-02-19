{-# OPTIONS -XOverloadedStrings #-}
module Freddy (respondTo) where

import Network.AMQP
import qualified Data.Text as T
import Data.Aeson (encode, decode)
import qualified Data.ByteString.Lazy.Char8 as BL
import Responses.SampleResponse (sampleResponse)
import Requests.SampleRequest (SampleRequest)

respondTo :: String -> (Channel -> (Message, Envelope) -> IO ()) -> IO ()
respondTo queueName callback = do
  conn <- openConnection "127.0.0.1" "/" "guest" "guest"
  chan <- openChannel conn

  declareQueue chan newQueue {queueName = T.pack queueName}

  consumeMsgs chan (T.pack queueName) NoAck (callback chan)

  getLine -- wait for keypress
  closeConnection conn
  putStrLn "connection closed"

buildReply :: Message -> Maybe (T.Text, Message)
buildReply originalMsg = do
  request <- (decode (msgBody originalMsg) :: Maybe SampleRequest)
  queueName <- msgReplyTo originalMsg
  let reply = newMsg {msgBody = (encode $ sampleResponse $ show request),
                      msgCorrelationID = (msgCorrelationID originalMsg),
                      msgDeliveryMode = Just NonPersistent}
  Just $ (queueName, reply)

sampleCallback :: Channel -> (Message, Envelope) -> IO ()
sampleCallback channel (msg, env) = do
  putStrLn $ "Received message: " ++ (show msg)

  case buildReply msg of
    Just (queueName, reply) -> (publishMsg channel "" queueName reply)
    Nothing -> putStrLn $ "Could not reply"
