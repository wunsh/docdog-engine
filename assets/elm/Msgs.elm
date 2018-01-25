module Msgs exposing (..)

import Models exposing (Line, Lines)
import RemoteData exposing (WebData)

type Msg
    = NoOp
    | OnFetchLines (WebData Lines)