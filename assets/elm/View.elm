module View exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Lines.List
import Models exposing (DocumentId, Model, Route(..))
import Msgs exposing (Msg)
import RemoteData


view : Model -> Html Msg
view model =
    div [ class "elm-app" ] [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        EditorRoute _ documentId ->
            editorPage model documentId

        NotFoundRoute ->
            notFoundView


editorPage : Model -> DocumentId -> Html Msg
editorPage model documentId =
    Lines.List.view model.lines


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
