module Commands exposing (..)

import Helper as H
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, hardcoded, required)
import Json.Encode as Encode
import Models exposing (DocumentId, Line, LineId, Lines, Status(..))
import Msgs exposing (Msg)
import RemoteData


-- Commands


saveLineCmd : Maybe Line -> Cmd Msg
saveLineCmd maybeLine =
    let
        command =
            case maybeLine of
                Just line ->
                    line
                        |> H.addDigestToLine
                        |> saveLineRequest
                        |> Http.send Msgs.OnLineSave

                Nothing ->
                    Cmd.none
    in
    command



-- Actions


fetchLines : DocumentId -> Cmd Msg
fetchLines documentId =
    Http.get (fetchLinesUrl documentId) linesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchLines


saveLineRequest : Line -> Http.Request Line
saveLineRequest line =
    Http.request
        { body = lineEncoder line |> Http.jsonBody
        , expect = Http.expectJson lineDecoder
        , headers = []
        , method = "PATCH"
        , timeout = Nothing
        , url = saveLineUrl line.id
        , withCredentials = False
        }



-- Urls


fetchLinesUrl : DocumentId -> String
fetchLinesUrl documentId =
    "/api/v1/documents/" ++ toString documentId ++ "/lines"


saveLineUrl : LineId -> String
saveLineUrl lineId =
    "/api/v1/lines/" ++ toString lineId



-- Encoders


lineEncoder : Line -> Encode.Value
lineEncoder line =
    let
        attributes =
            [ ( "id", Encode.int line.id )
            , ( "translated_text", Encode.string (Maybe.withDefault "" line.translatedText) )
            ]
    in
    Encode.object
        [ ( "line", Encode.object attributes )
        ]



-- Decoders


linesDecoder : Decode.Decoder Lines
linesDecoder =
    Decode.at [ "data" ] (Decode.list lineDecoder)


lineDecoder : Decode.Decoder Line
lineDecoder =
    decode Line
        |> required "id" Decode.int
        |> required "original_text" Decode.string
        |> required "translated_text" (Decode.nullable Decode.string)
        -- For `initialTranslatedText` field
        |> required "translated_text" (Decode.nullable Decode.string)
        |> hardcoded ""
        |> hardcoded Default
