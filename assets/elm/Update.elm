module Update exposing (..)

import Commands exposing (saveLineCmd)
import Dom
import Helper as H
import Keyboard.Extra exposing (Key(..))
import MD5
import Models exposing (HeldMetaKeys, Line, Lines, Model, Status(..))
import Msgs exposing (Msg(..))
import RemoteData exposing (WebData)
import Routing exposing (parseLocation)
import Task
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

        KeyUp key ->
            let
                heldMetaKeys =
                    model.heldMetaKeys

                updatedHeldMetaKeys =
                    releaseMetaKey key heldMetaKeys
            in
            { model | heldMetaKeys = updatedHeldMetaKeys } ! []

        KeyDown key ->
            let
                heldMetaKeys =
                    model.heldMetaKeys

                updatedHeldMetaKeys =
                    pressMetaKey key heldMetaKeys
            in
            case model.currentLineId of
                Just lineId ->
                    if key == Escape then
                        let
                            updateLine line =
                                if line.id == lineId then
                                    { line | translatedText = line.initialTranslatedText, status = Default }
                                else
                                    line

                            updatedLines =
                                RemoteData.Success (List.map updateLine (maybeList model.lines))

                            updatedModel =
                                { model | lines = updatedLines, heldMetaKeys = updatedHeldMetaKeys }
                        in
                        updatedModel ! []
                    else if isPressed [ Super, Enter ] updatedHeldMetaKeys then
                        let
                            updatedLine =
                                List.head (List.filter (\m -> m.id == lineId) (maybeList model.lines))
                        in
                        { model | heldMetaKeys = updatedHeldMetaKeys } ! [ saveLineCmd updatedLine ]
                    else
                        { model | heldMetaKeys = updatedHeldMetaKeys } ! []

                Nothing ->
                    model ! []

        UpdateCurrentLine newTranslatedText ->
            case model.currentLineId of
                Just lineId ->
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
                    updatedModel
                        ! []

                Nothing ->
                    model
                        ! []

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

        OnLineFocus lineId ->
            { model | currentLineId = Just lineId }
                ! []

        OnLineBlur lineId ->
            { model | currentLineId = Nothing }
                ! []

        OnLineSave (Ok line) ->
            let
                translatedText =
                    Maybe.withDefault "" line.translatedText

                updatedLine =
                    { line | initialTranslatedText = line.translatedText, initialDigest = H.computeDigest translatedText, status = Saved }

                nextLine =
                    getNextLineOrCurrent line (maybeList model.lines)

                makeNextLineFocusedCommand =
                    if nextLine == line then
                        Cmd.none
                    else
                        Dom.focus ("line_" ++ toString nextLine.id) |> Task.attempt FocusLine
            in
            updateModel model updatedLine
                ! [ H.setTimeout (Time.second * 5) <| ChangeLineStatus line.id, makeNextLineFocusedCommand ]

        OnLineSave (Err error) ->
            ( model, Cmd.none )

        FocusLine result ->
            ( model, Cmd.none )


maybeList : WebData (List Line) -> List Line
maybeList response =
    case response of
        RemoteData.Success lines ->
            lines

        _ ->
            []


pressMetaKey : Key -> HeldMetaKeys -> HeldMetaKeys
pressMetaKey key keys =
    updateHeldMetaKeys key True keys


releaseMetaKey : Key -> HeldMetaKeys -> HeldMetaKeys
releaseMetaKey key keys =
    updateHeldMetaKeys key False keys


updateHeldMetaKeys : Key -> Bool -> HeldMetaKeys -> HeldMetaKeys
updateHeldMetaKeys key isPressed keys =
    case key of
        Alt ->
            { keys | alt = isPressed }

        Control ->
            { keys | control = isPressed }

        Enter ->
            { keys | enter = isPressed }

        Shift ->
            { keys | shift = isPressed }

        Super ->
            -- Workaround for bug with `Cmd + Enter` combination
            if isPressed then
                { keys | super = isPressed }
            else
                Models.initialHeldMetaKeys

        ContextMenu ->
            if isPressed then
                { keys | super = isPressed }
            else
                Models.initialHeldMetaKeys

        _ ->
            keys


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


getNextLineOrCurrent : Line -> Lines -> Line
getNextLineOrCurrent currentLine lines =
    let
        lineId =
            currentLine.id

        findNextInList l =
            case l of
                [] ->
                    currentLine

                x :: [] ->
                    if x.id == lineId then
                        Maybe.withDefault currentLine (List.head lines)
                    else
                        currentLine

                x :: y :: rest ->
                    if x.id == lineId then
                        y
                    else
                        findNextInList (y :: rest)
    in
    findNextInList lines


isPressed : List Key -> HeldMetaKeys -> Bool
isPressed needCheckKeys pressedKeys =
    let
        keyIncludedIn key =
            case key of
                Alt ->
                    pressedKeys.alt

                Control ->
                    pressedKeys.control

                Enter ->
                    pressedKeys.enter

                Shift ->
                    pressedKeys.shift

                Super ->
                    pressedKeys.super

                ContextMenu ->
                    pressedKeys.super

                _ ->
                    False
    in
    List.all keyIncludedIn needCheckKeys
