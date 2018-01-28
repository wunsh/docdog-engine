module Msgs exposing (..)

import Http
import Models exposing (Line, LineId, Lines)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = NoOp
    | UpdateLine LineId String
    | SaveLine LineId
    | OnLocationChange Location
    | OnFetchLines (WebData Lines)
    | OnLineSave (Result Http.Error Line)
    | ChangeLineStatus LineId
    | NotFoundError
