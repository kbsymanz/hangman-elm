module Picture.Main exposing (..)

import AnimationFrame as AF
import Html exposing (Html)
import Html.App as Html
import Keyboard exposing (presses)
import Task
import Window

-- LOCAL IMPORTS

import Picture.Model exposing (Model)
import Picture.Update exposing (update, Msg(..))
import Picture.View exposing (view)

main =
    let
        initModel : Model {}
        initModel =
            { allowedIncorrectGuesses = 1
            , incorrectGuesses = 0
            , correctGuesses = 0
            , windowWidth = 0
            , windowHeight = 0
            , animationStep = 0
            }

        modelWithEffects =
            update Init initModel
    in
        Html.program
            { init = modelWithEffects
            , view = view
            , update = update
            , subscriptions = subscriptions
            }


subscriptions model =
    Sub.batch
        [ Keyboard.presses Incorrect
        , Window.resizes WindowResize
        , AF.diffs AnimationStep
        ]
