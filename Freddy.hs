{-# OPTIONS -XOverloadedStrings #-}
module Freddy (connect, respondTo) where

import Network.AMQP
import qualified Data.Text as T
import Data.Aeson (encode, decode, ToJSON)
import qualified Data.ByteString.Lazy.Char8 as BL
import Responses.SampleResponse (sampleResponse, SampleResponse)
import Requests.SampleRequest (SampleRequest)

connect :: String -> T.Text -> T.Text -> T.Text -> IO Connection
connect host vhost user password =
  openConnection "127.0.0.1" "/" "guest" "guest"

respondTo :: (ToJSON r) => Connection -> String -> (String -> r) -> IO ConsumerTag
respondTo conn queueName callback = do
  chan <- openChannel conn

  declareQueue chan newQueue {queueName = T.pack queueName}

  consumeMsgs chan (T.pack queueName) NoAck (replyCallback callback chan)

replyCallback userCallback channel (msg, env) = do
  --putStrLn $ "Received message: " ++ (show msg)
  let response = userCallback "some content"

  case buildReply msg response of
    Just (queueName, reply) -> (publishMsg channel "" queueName reply)
    Nothing -> putStrLn $ "Could not reply"

buildReply :: (ToJSON r) => Message -> r -> Maybe (T.Text, Message)
buildReply originalMsg response = do
  request <- (decode (msgBody originalMsg) :: Maybe SampleRequest)
  queueName <- msgReplyTo originalMsg
  let reply = newMsg {msgBody = (encode $ response),
                      msgCorrelationID = (msgCorrelationID originalMsg),
                      msgDeliveryMode = Just NonPersistent}
  Just $ (queueName, reply)
