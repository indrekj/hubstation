{-# OPTIONS -XOverloadedStrings #-}
module Freddy (connect, respondTo) where

import Network.AMQP
import qualified Data.Text as T
import qualified Data.ByteString.Lazy.Char8 as BL

connect :: String -> T.Text -> T.Text -> T.Text -> IO Connection
connect host vhost user password =
  openConnection host vhost user password

respondTo :: Connection -> String -> (BL.ByteString -> Either BL.ByteString BL.ByteString) -> IO ConsumerTag
respondTo conn queueName callback = do
  chan <- openChannel conn

  declareQueue chan newQueue {queueName = T.pack queueName}

  consumeMsgs chan (T.pack queueName) NoAck (replyCallback callback chan)

replyCallback :: (BL.ByteString -> Either BL.ByteString BL.ByteString) -> Channel -> (Message, Envelope) -> IO ()
replyCallback userCallback channel (msg, env) = do
  let requestBody = msgBody msg
  let (t, body) = extractResult $ userCallback requestBody

  case buildReply msg t body of
    Just (queueName, reply) -> (publishMsg channel "" queueName reply)
    Nothing -> putStrLn $ "Could not reply"

buildReply :: Message -> String -> BL.ByteString -> Maybe (T.Text, Message)
buildReply originalMsg t body = do
  queueName <- msgReplyTo originalMsg

  let reply = newMsg {
    msgBody          = body,
    msgCorrelationID = msgCorrelationID originalMsg,
    msgDeliveryMode  = Just NonPersistent,
    msgType          = Just $ T.pack t
  }

  Just $ (queueName, reply)

extractResult :: Either BL.ByteString BL.ByteString -> (String, BL.ByteString)
extractResult response = case response of
  Right r -> ("success", r)
  Left r -> ("error", r)
