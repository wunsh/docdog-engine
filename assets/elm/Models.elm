module Models exposing (..)

import RemoteData exposing (WebData)


type alias Model =
    { lines : WebData Lines
    , route : Route
    }


initialModel : Route -> Model
initialModel route =
    { lines = RemoteData.Loading
    , route = route
    }


type Route
    = EditorRoute Int DocumentId
    | NotFoundRoute


type Status
    = Default
    | Active
    | Changed
    | Saved


type alias Lines =
    List Line


type alias Line =
    { id : LineId
    , originalText : String
    , translatedText : Maybe String
    , initialTranslatedText : Maybe String
    , initialDigest : String
    , status : Status
    }


type alias LineId =
    Int


type alias DocumentId =
    Int
