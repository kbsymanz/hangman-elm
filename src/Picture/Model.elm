module Picture.Model exposing (..)

import Time

type alias Model a =
    { a
        | allowedIncorrectGuesses : Int
        , incorrectGuesses : Int
        , correctGuesses : Int
        , windowWidth : Int
        , windowHeight : Int
        , animationStep : Time.Time
    }


initModel : Model {}
initModel =
    { allowedIncorrectGuesses = 1
    , incorrectGuesses = 0
    , correctGuesses = 0
    , windowWidth = 0
    , windowHeight = 0
    , animationStep = 0.0
    }
