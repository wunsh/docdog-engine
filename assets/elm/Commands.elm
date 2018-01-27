module Commands exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Msgs exposing (Msg)
import Models exposing (DocumentId, LineId, Line, Lines)
import RemoteData

-- Commands

saveLineCmd : Maybe Line -> Cmd Msg
saveLineCmd maybeLine =
  let
    line = case maybeLine of 
      Just line -> line
      Nothing -> {id=0, originalText = "", translatedText = Nothing}
  in  
    saveLineRequest line
        |> Http.send Msgs.OnLineSave

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
    "http://localhost:4000/api/v1/documents/" ++ (toString documentId) ++ "/lines"

saveLineUrl : LineId -> String
saveLineUrl lineId =
    "http://localhost:4000/api/v1/lines/" ++ (toString lineId)

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
            [ ( "line",  Encode.object attributes )
            ]

       

-- Decoders

linesDecoder : Decode.Decoder Lines
linesDecoder =
    Decode.at ["data"] (Decode.list lineDecoder)

lineDecoder : Decode.Decoder Line
lineDecoder =
    decode Line
      |> required "id" Decode.int
      |> required "original_text" Decode.string
      |> required "translated_text" (Decode.nullable Decode.string)



