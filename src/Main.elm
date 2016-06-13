module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, div)
import Html.App as Html


-- LOCAL IMPORTS

import Phrase.Main as Phrase


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { phase : String
    , allowedGuesses : Int
    }


type Msg
    = NoOp
    | PhraseMsg Phrase.Msg


init : ( Model, Cmd Msg )
init =
    ( Model "" 7, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.section []
        [ Html.div []
            [ Html.h1 []
                [ Html.text "Hangman" ]
            , Html.div []
                [ Html.text "Picture goes here" ]
            , Html.div []
                [ Html.text "Letters used goes here" ]
            , Html.map PhraseMsg (Phrase.view (model {}))
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
