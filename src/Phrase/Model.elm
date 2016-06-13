module Phrase.Model exposing (..)

import Keyboard


type alias Model a =
    { a
        | phrase : String
        , letters : List Letter
        , allowedIncorrectGuesses : Int
        , incorrectGuesses : Int
        , correctGuesses : Int
        , gameStatus : GameStatus
    }


type LetterStatus
    = Guessed
    | Unguessed


type GameStatus
    = InProcess
    | Won
    | Lost


type alias Letter =
    { char : Char
    , guessed : LetterStatus
    }
