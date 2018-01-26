module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (parseLocation)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        NotFoundError ->
            ( model, Cmd.none )
        OnFetchLines response ->
            ( { model | lines = response }, Cmd.none )
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )
