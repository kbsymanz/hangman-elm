module Phrase.Main exposing (..)

import Dict exposing (Dict)
import Html exposing (Html)
import Html.App as Html
import Keyboard


-- LOCAL IMPORTS

import Phrase.Model exposing (Model)
import Phrase.Update exposing (update, Msg(..))
import Phrase.View exposing (view)


main =
    let
        initModel : Model {}
        initModel =
            { phrase = ""
            , letters = []
            , allowedIncorrectGuesses = 1
            , incorrectGuesses = 0
            , correctGuesses = 0
            , incorrectLettersGuessed = []
            }

        modelWithEffects =
            update (Init "This is a Test" 7) initModel
    in
        Html.program
            { init = modelWithEffects
            , view = view
            , update = update
            , subscriptions = subscriptions
            }



--subscriptions : Model -> Sub Msg


subscriptions model =
    Sub.batch
        [ Keyboard.presses Keypress
        ]
