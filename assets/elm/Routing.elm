module Routing exposing (..)

import Debug
import Models exposing (Route(..))
import Navigation exposing (Location)
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map EditorRoute (s "workplace" </> s "projects" </> int </> s "documents" </> int </> s "edit")
        ]


parseLocation : Location -> Route
parseLocation location =
    case parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
