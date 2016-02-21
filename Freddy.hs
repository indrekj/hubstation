{-# OPTIONS -XOverloadedStrings #-}
module Freddy (connect, respondTo) where

import Network.AMQP
import qualified Data.Text as T
import qualified Data.ByteString.Lazy.Char8 as BL

connect :: String -> T.Text -> T.Text -> T.Text -> IO Connection
connect host vhost user password =
  openConnection host vhost user password

respondTo :: Connection -> String -> (BL.ByteString -> BL.ByteString) -> IO ConsumerTag
respondTo conn queueName callback = do
  chan <- openChannel conn

  declareQueue chan newQueue {queueName = T.pack queueName}

  consumeMsgs chan (T.pack queueName) NoAck (replyCallback callback chan)

replyCallback :: (BL.ByteString -> BL.ByteString) -> Channel -> (Message, Envelope) -> IO ()
replyCallback userCallback channel (msg, env) = do
  case buildReply msg userCallback of
    Just (queueName, reply) -> (publishMsg channel "" queueName reply)
    Nothing -> putStrLn $ "Could not reply"

buildReply :: Message -> (BL.ByteString -> BL.ByteString) -> Maybe (T.Text, Message)
buildReply originalMsg userCallback = do
  let requestBody = msgBody originalMsg
  queueName <- msgReplyTo originalMsg

  let reply = newMsg {
    msgBody          = userCallback requestBody,
    msgCorrelationID = msgCorrelationID originalMsg,
    msgDeliveryMode  = Just NonPersistent,
    msgType          = Just "success"
  }

  Just $ (queueName, reply)
