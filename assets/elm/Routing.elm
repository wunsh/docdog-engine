module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (Route(..))
import UrlParser exposing (..)
import Debug

matchers : Parser (Route -> a) a
matchers = 
  oneOf 
    [ map EditorRoute (s "workplace" </> s "projects" </> int </> s "documents" </> int </> s "edit") 
    ]

parseLocation : Location -> Route
parseLocation location =
  case (parsePath matchers location) of
      Just route ->
          route
          
      Nothing ->
          NotFoundRoute
