module Msgs exposing (..)

import Dom
import Http
import Keyboard.Extra exposing (Key)
import Models exposing (Line, LineId, Lines)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = NoOp
    | UpdateCurrentLine String
    | OnLocationChange Location
    | OnFetchLines (WebData Lines)
    | OnLineSave (Result Http.Error Line)
    | OnLineFocus LineId
    | OnLineBlur LineId
    | KeyDown Key
    | KeyUp Key
    | ChangeLineStatus LineId
    | FocusLine (Result Dom.Error ())
    | NotFoundError
