module Helper exposing (..)

import MD5
import Models exposing (Line, Status)
import Process
import Task
import Time exposing (Time)


changeLineStatus : Status -> Line -> Line
changeLineStatus newStatus line =
    { line | status = newStatus }


addDigestToLine : Line -> Line
addDigestToLine line =
    { line | initialDigest = computeDigest (Maybe.withDefault "" line.translatedText) }


computeDigest : String -> String
computeDigest =
    MD5.hex


setTimeout : Time -> msg -> Cmd msg
setTimeout delay msg =
    Process.sleep delay
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity
