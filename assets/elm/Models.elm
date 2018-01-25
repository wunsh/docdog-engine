module Models exposing (..)

import RemoteData exposing (WebData)

type alias Model =
  { lines : WebData Lines
  }

initialModel : Model
initialModel =
  { lines = RemoteData.Loading
  }

type alias Lines =
  List Line

type alias Line =
  { id: LineId
  , originalText : String
  , translatedText : String 
  }

type alias LineId =
  Int