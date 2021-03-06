module Phrase.Model exposing (..)

import Keyboard


type alias Model a =
    { a
        | phrase : String
        , letters : List Letter
        , allowedIncorrectGuesses : Int
        , incorrectGuesses : Int
        , correctGuesses : Int
        , incorrectLettersGuessed : List Char
    }


type LetterStatus
    = Guessed
    | Unguessed


type alias Letter =
    { char : Char
    , guessed : LetterStatus
    }
