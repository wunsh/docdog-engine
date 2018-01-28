module Lines.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, disabled, id, rows, value)
import Html.Events exposing (keyCode, on, onBlur, onClick, onFocus, onInput)
import Json.Decode as Json
import Models exposing (Line, Lines, Status(..))
import Msgs exposing (Msg)
import RemoteData exposing (WebData)


view : WebData Lines -> Html Msg
view response =
    table [ class "editor table" ]
        [ renderHeading
        , maybeList response
        ]


renderHeading : Html Msg
renderHeading =
    thead []
        [ tr []
            [ th [] [ text "Original Text" ]
            , th [] [ text "Translated Text" ]
            ]
        ]


renderLines : Lines -> Html Msg
renderLines lines =
    let
        renderedLines =
            List.map renderLine lines
    in
    tbody [] renderedLines


renderLine : Line -> Html Msg
renderLine line =
    tr []
        [ td [] [ strong [] [ text line.originalText ] ]
        , td [] [ renderTranslateForm line ]
        ]


renderTranslateForm : Line -> Html Msg
renderTranslateForm line =
    textarea
        [ id ("line_" ++ toString line.id)
        , value (Maybe.withDefault "" line.translatedText)
        , rows 5
        , class "translate_line__input translate_input form-control"
        , class (statusToString line.status)
        , onInput Msgs.UpdateCurrentLine
        , onFocus (Msgs.OnLineFocus line.id)
        , onBlur (Msgs.OnLineBlur line.id)
        ]
        []


statusToString : Status -> String
statusToString status =
    "translate_input--" ++ String.toLower (toString status)


maybeList : WebData Lines -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success lines ->
            renderLines lines

        RemoteData.Failure error ->
            text (toString error)
