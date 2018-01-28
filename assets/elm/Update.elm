module Update exposing (..)

import Commands exposing (saveLineCmd)
import Helper as H
import MD5
import Models exposing (Line, Lines, Model, Status(..))
import Msgs exposing (Msg(..))
import RemoteData exposing (WebData)
import Routing exposing (parseLocation)
import Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        NotFoundError ->
            ( model, Cmd.none )

        OnFetchLines response ->
            let
                addDigestToLines lines =
                    List.map (\l -> H.addDigestToLine l) lines

                responseWithDigest =
                    case response of
                        RemoteData.Success lines ->
                            RemoteData.Success (addDigestToLines lines)

                        _ ->
                            response
            in
            ( { model | lines = responseWithDigest }, Cmd.none )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
            ( { model | route = newRoute }, Cmd.none )

        UpdateLine lineId newTranslatedText ->
            let
                determineStatus line =
                    if line.initialDigest == H.computeDigest newTranslatedText then
                        Default
                    else
                        Changed

                updateLine line =
                    if line.id == lineId then
                        { line | translatedText = Just newTranslatedText, status = determineStatus line }
                    else
                        line

                updatedLines =
                    RemoteData.Success (List.map updateLine (maybeList model.lines))

                updatedModel =
                    { model | lines = updatedLines }
            in
            ( updatedModel, Cmd.none )

        SaveLine lineId ->
            let
                updatedLine =
                    List.head (List.filter (\m -> m.id == lineId) (maybeList model.lines))
            in
            ( model, saveLineCmd updatedLine )

        ChangeLineStatus lineId ->
            let
                line =
                    List.head (List.filter (\m -> m.id == lineId) (maybeList model.lines))

                updatedLine line =
                    { line | initialDigest = H.computeDigest (Maybe.withDefault "" line.translatedText), status = Default }

                updatedModel =
                    case line of
                        Just line ->
                            updateModel model (updatedLine line)

                        Nothing ->
                            model
            in
            updatedModel
                ! []

        OnLineSave (Ok line) ->
            let
                translatedText =
                    Maybe.withDefault "" line.translatedText

                updatedLine =
                    { line | initialDigest = H.computeDigest translatedText, status = Saved }
            in
            updateModel model updatedLine
                ! [ H.setTimeout (Time.second * 5) <| ChangeLineStatus line.id ]

        OnLineSave (Err error) ->
            ( model, Cmd.none )


maybeList : WebData (List Line) -> List Line
maybeList response =
    case response of
        RemoteData.Success lines ->
            lines

        _ ->
            []


updateModel : Model -> Line -> Model
updateModel model updatedLine =
    let
        pick currentLine =
            if updatedLine.id == currentLine.id then
                updatedLine
            else
                currentLine

        updateLineList lines =
            List.map pick lines

        updatedLines =
            RemoteData.map updateLineList model.lines
    in
    { model | lines = updatedLines }
