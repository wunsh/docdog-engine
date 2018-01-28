module Main exposing (..)

import Char
import Commands exposing (fetchLines)
import Html
import Keyboard
import Keyboard.Extra
import Lines.List
import Models exposing (Model, Route(..), initialModel)
import Msgs exposing (Msg(..))
import Navigation exposing (Location)
import Routing
import Update exposing (update)
import View exposing (view)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location

        command =
            case currentRoute of
                EditorRoute _ documentId ->
                    fetchLines documentId

                NotFoundRoute ->
                    Cmd.none
    in
    ( initialModel currentRoute, command )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.Extra.downs KeyDown
        , Keyboard.Extra.ups KeyUp
        ]



-- MAIN


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
