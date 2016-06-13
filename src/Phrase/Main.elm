module Phrase.Main exposing (..)

{-| Requirements:
    x. Operate stand-alone using it's own Main module as the driver.
    x. Initialize with a String passed from the parent.
    x. Initialize with number of allowed guesses from the parent.
    x. Expose a view which handles keyboard input.
    x. Keyboard input should result in messages.
    x. Should track which letters have been guessed.
    x. Should track number of guesses incorrect.
    x. Should end the game when the number of incorrect guesses allowed is reached.
    x. Should expose a model field representing the number of incorrect guesses currently.
    x. Should show letters in view that are guessed correctly when they are guessed.
    x. Spaces are not part of the guessing.
    x. Move subscriptions to another module.
    x. Refactor the look of the stats.
    x. Store a win or lose in the model.
    x. Consider combining the gameFinished field with the win/lose field.
    x. Display "You WON!" or "Sorry, you lost" at the end.
    x. Do not increment correctly guessed for a letter that is already guessed.
-}

import Dict exposing (Dict)
import Html exposing (Html)
import Html.App as Html
import Html.Events exposing (onClick)
import Keyboard
import String


-- LOCAL IMPORTS

import Phrase.Model exposing (Model, GameStatus(..))
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
            , gameStatus = InProcess
            }

        modelWithEffects =
            update (InitGame "This is a Test" 7) initModel
    in
        Html.program
            { init = modelWithEffects
            , view = view
            , update = update
            , subscriptions = Phrase.Update.subscriptions
            }
