module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, div)
import Html.App as Html
import Keyboard
import Time exposing (Time, second)


-- LOCAL IMPORTS

import Phrase.Main as Phrase
import Phrase.Model as Phrase
import Phrase.Update as Phrase
import Phrase.View as Phrase


main =
    let
        initModel : Model
        initModel =
            { phrase = ""
            , letters = []
            , allowedIncorrectGuesses = 1
            , incorrectGuesses = 0
            , correctGuesses = 0
            , gameStatus = Phrase.InProcess
            }

        (( model, effects ) as modelWithEffects) =
            Phrase.InitGame "This is another test" 7
                |> PhraseMsg
                |> flip update initModel
    in
        Html.program
            { init = modelWithEffects
            , view = view
            , update = update
            , subscriptions = subscriptions
            }


type alias Model =
    { phrase : String
    , letters : List Phrase.Letter
    , allowedIncorrectGuesses : Int
    , incorrectGuesses : Int
    , correctGuesses : Int
    , gameStatus : Phrase.GameStatus
    }


type Msg
    = NoOp
    | PhraseMsg Phrase.Msg
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        PhraseMsg msg ->
            let
                ( phrModel, phrCmd ) =
                    Phrase.update msg model
            in
                ( phrModel, Cmd.map PhraseMsg phrCmd )

        Tick time ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.section []
        [ Html.div []
            [ Html.h1 []
                [ Html.text "Hangman" ]
            , Html.div []
                [ Html.text "Picture goes here" ]
            , Html.map PhraseMsg (Phrase.view model)
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map PhraseMsg (Keyboard.presses Phrase.Keypress)
