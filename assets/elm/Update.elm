module Update exposing (..)

import Commands exposing (saveLineCmd)
import Models exposing (Line, Lines, Model)
import Msgs exposing (Msg(..))
import RemoteData exposing (WebData)
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

        UpdateLine lineId newTranslatedText ->
            let
                updateLine line =
                    if line.id == lineId then
                        { line | translatedText = Just newTranslatedText }
                    else
                        line

                updatedModel =
                    { model | lines = RemoteData.Success (List.map updateLine (maybeList model.lines)) }
            in
            ( updatedModel, Cmd.none )

        SaveLine lineId ->
            let
                updatedLine =
                    List.head (List.filter (\m -> m.id == lineId) (maybeList model.lines))
            in
            ( model, saveLineCmd updatedLine )

        OnLineSave (Ok line) ->
            ( updateLine model line, Cmd.none )

        OnLineSave (Err error) ->
            ( model, Cmd.none )


maybeList : WebData Lines -> List Line
maybeList response =
    case response of
        RemoteData.Success lines ->
            lines

        otherwise ->
            []


updateLine : Model -> Line -> Model
updateLine model updatedLine =
    let
        pick currentLine =
            if updatedLine.id == updatedLine.id then
                updatedLine
            else
                currentLine

        updateLineList lines =
            List.map pick lines

        updatedLines =
            RemoteData.map updateLineList model.lines
    in
    { model | lines = updatedLines }
