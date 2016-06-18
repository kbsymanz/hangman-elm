module Words.Model exposing (..)

import Random


type alias Model a =
    { a
        | phrase : String
    }


initialModel : Model {}
initialModel =
    { phrase = "" }


words : List String
words =
    [ "The time is now"
    , "This is another test"
    , "Simply fascinating"
    , "Wonder of wonders"
    , "Elm is a functional programming language"
    , "Cats and dogs"
    , "Caring about people"
    , "Truly amazing"
    , "A word list"
    , "Running into troubles"
    , "What was that again"
    ]
