module Models exposing (..)

import RemoteData exposing (WebData)


type alias Model =
    { lines : WebData Lines
    , currentLineId : Maybe LineId
    , route : Route
    , heldMetaKeys : HeldMetaKeys
    }


initialModel : Route -> Model
initialModel route =
    { lines = RemoteData.Loading
    , currentLineId = Nothing
    , route = route
    , heldMetaKeys = initialHeldMetaKeys
    }


initialHeldMetaKeys : HeldMetaKeys
initialHeldMetaKeys =
    { alt = False
    , control = False
    , enter = False
    , shift = False
    , super = False
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


type alias HeldMetaKeys =
    { alt : Bool
    , control : Bool
    , enter : Bool
    , shift : Bool
    , super : Bool
    }


type alias LineId =
    Int


type alias DocumentId =
    Int
