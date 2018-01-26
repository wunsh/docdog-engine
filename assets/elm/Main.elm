module Main exposing (..)

import Html
import Msgs exposing (Msg(..))
import Models exposing (Route(..), Model, initialModel)
import Update exposing (update)
import View exposing (view)
import Commands exposing (fetchLines)
import Lines.List
import Navigation exposing (Location)
import Routing

init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
          Routing.parseLocation location
        command = 
          case currentRoute of
            EditorRoute _ documentId -> fetchLines documentId
            NotFoundRoute -> Cmd.none
    in
        ( initialModel currentRoute, command )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- MAIN

main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }