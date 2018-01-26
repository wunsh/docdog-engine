module Msgs exposing (..)

import Models exposing (Line, Lines)
import RemoteData exposing (WebData)
import Navigation exposing (Location)

type Msg
    = NoOp
    | OnFetchLines (WebData Lines)
    | OnLocationChange Location
    | NotFoundError
