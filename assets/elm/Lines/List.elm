module Lines.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value)
import Msgs exposing (Msg)
import Models exposing (Lines, Line)
import RemoteData exposing (WebData)

view : WebData Lines -> Html Msg
view response =
    table [ class "editor table" ] [
        renderHeading,
        maybeList response
    ]

renderHeading : Html Msg
renderHeading =
    thead [] 
        [ tr []
            [ th [] [ text "Original Text" ]
            , th [] [ text "Translated Text"] ] ]       

renderLines : Lines -> Html Msg
renderLines lines =
    let
        renderedLines = List.map renderLine lines            
    in
        tbody [] renderedLines
  
renderLine : Line -> Html Msg
renderLine line =
    tr []
        [ td [] [ strong [] [ text line.originalText ] ]
        , td [] [ renderTranslateForm line ] ]

renderTranslateForm : Line -> Html Msg
renderTranslateForm line =
    input
        [ value (Maybe.withDefault "" line.translatedText)
        , class "translate_line__input translate_input form-control"
        ]
        [] 

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
