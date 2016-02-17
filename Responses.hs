module Responses ( engagementCreatedResponse ) where

import Models

engagementCreatedResponse :: Operator -> Visitor -> String
engagementCreatedResponse operator visitor =
  "Engagement created for operator "
    ++ operatorName operator
    ++ " and visitor "
    ++ visitorName visitor

