module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, div)
import Html.App as Html
import Html.Attributes as HA
import Html.Events as HE
import Keyboard
import Window


-- LOCAL IMPORTS

import Phrase.Model as Phrase
import Phrase.Update as Phrase
import Phrase.View as Phrase
import Picture.Model as Picture
import Picture.Update as Picture
import Picture.View as Picture


main =
    Html.program
        { init = initGame
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { phrase : String
    , letters : List Phrase.Letter
    , allowedIncorrectGuesses : Int
    , incorrectGuesses : Int
    , correctGuesses : Int
    , windowWidth : Int
    , windowHeight : Int
    , gameStatus : GameStatus
    }


initModel : Model
initModel =
    { phrase = ""
    , letters = []
    , allowedIncorrectGuesses = 1
    , incorrectGuesses = 0
    , correctGuesses = 0
    , windowWidth = 0
    , windowHeight = 0
    , gameStatus = InProcess
    }



-- UPDATE


type GameStatus
    = InProcess
    | Won
    | Lost


type Msg
    = NoOp
    | PhraseMsg Phrase.Msg
    | PictureMsg Picture.Msg
    | NewGame


initGame : ( Model, Cmd Msg )
initGame =
    let
        ( phrModel, phrCmd ) =
            Phrase.InitGame "This is another test" 7
                |> PhraseMsg
                |> flip update initModel

        ( picModel, picCmd ) =
            Picture.InitGame
                |> PictureMsg
                |> flip update phrModel
    in
        ( picModel, Cmd.batch [ phrCmd, picCmd ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        PhraseMsg msg ->
            let
                ( phrModel, phrCmd ) =
                    Phrase.update msg model

                -- Set the gameStatus field.
                newModel =
                    if phrModel.incorrectGuesses >= phrModel.allowedIncorrectGuesses then
                        { phrModel | gameStatus = Lost }
                    else if Phrase.numLettersLeft phrModel.letters == 0 then
                        { phrModel | gameStatus = Won }
                    else
                        phrModel
            in
                ( newModel, Cmd.map PhraseMsg phrCmd )

        PictureMsg msg ->
            let
                ( picModel, picCmd ) =
                    Picture.update msg model
            in
                ( picModel, Cmd.map PictureMsg picCmd )

        NewGame ->
            initGame



-- VIEW


(=>) =
    (,)


viewGameOver : Model -> Html Msg
viewGameOver model =
    let
        outerDivStyle =
            HA.style [ "margin" => "20px" ]

        congratsStyle =
            HA.style [ "font-size" => "150%" ]

        buttonStyle =
            HA.style
                [ "position" => "relative"
                , "float" => "right"
                ]

        msg =
            case model.gameStatus of
                InProcess ->
                    ""

                Won ->
                    "Congrats, you won!"

                Lost ->
                    "Sorry, you lost."
    in
        Html.div [ outerDivStyle ]
            [ Html.span [ congratsStyle ]
                [ Html.text msg ]
            , Html.button [ buttonStyle, HE.onClick NewGame ]
                [ Html.text "New Game" ]
            ]


view : Model -> Html Msg
view model =
    let
        marginStyle =
            HA.style [ "margin" => "20px" ]

    in
        Html.section []
            [ Html.div []
                [ Html.h1 [ marginStyle ]
                    [ Html.text "Hangman" ]
                , Html.div
                    [ marginStyle ]
                    [ Html.map PictureMsg (Picture.view model) ]
                , Html.map PhraseMsg (Phrase.view model)
                , Html.map identity (viewGameOver model)
                ]
            ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        subs =
            if model.gameStatus == InProcess then
                Sub.batch
                    [ Sub.map PhraseMsg (Keyboard.presses Phrase.Keypress)
                    , Sub.map PictureMsg (Window.resizes Picture.WindowResize)
                    ]
            else
                Sub.none
    in
        subs
