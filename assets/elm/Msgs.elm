module Msgs exposing (..)

import Models exposing (Line, Lines, LineId)
import RemoteData exposing (WebData)
import Navigation exposing (Location)
import Http

type Msg
    = NoOp
    | UpdateLine LineId String
    | SaveLine LineId
    | OnLocationChange Location
    | OnFetchLines (WebData Lines)
    | OnLineSave (Result Http.Error Line)
    | NotFoundError
