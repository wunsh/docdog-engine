module View exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Msgs exposing (Msg)
import Models exposing (Model)
import Lines.List

view : Model -> Html Msg
view model = 
  div [ class "elm-app" ] [ page model ]

page : Model -> Html Msg
page model =
    Lines.List.view model.lines