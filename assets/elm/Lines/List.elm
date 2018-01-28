module Lines.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, disabled, rows, value)
import Html.Events exposing (keyCode, on, onClick, onInput)
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
            , th [] [ text "Buttons" ]
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
        , td []
            [ button
                [ onClick (Msgs.SaveLine line.id)
                , disabled (line.status == Default)
                ]
                [ text "Save" ]
            ]
        ]


renderTranslateForm : Line -> Html Msg
renderTranslateForm line =
    textarea
        [ value (Maybe.withDefault "" line.translatedText)
        , rows 5
        , class "translate_line__input translate_input form-control"
        , class (statusToString line.status)
        , onInput (Msgs.UpdateLine line.id)
        , onKeyDown (Msgs.KeyDown line.id)
        ]
        []


statusToString : Status -> String
statusToString status =
    "translate_input--" ++ String.toLower (toString status)


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


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
