module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Msgs exposing (Msg)
import Models exposing (DocumentId, Line, Lines)
import RemoteData

fetchLines : DocumentId -> Cmd Msg
fetchLines documentId =
    Http.get (fetchLinesUrl documentId) linesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchLines

fetchLinesUrl : Int -> String
fetchLinesUrl documentId =
    "http://localhost:4000/api/v1/documents/" ++ (toString documentId) ++ "/lines"

linesDecoder : Decode.Decoder Lines
linesDecoder =
    Decode.at ["data"] (Decode.list lineDecoder)

lineDecoder : Decode.Decoder Line
lineDecoder =
    decode Line
      |> required "id" Decode.int
      |> required "original_text" Decode.string
      |> required "translated_text" (Decode.nullable Decode.string)