module Main exposing (..)

import AnimationFrame as AF
import Dict exposing (Dict)
import Html exposing (Html, div)
import Html.App as Html
import Html.Attributes as HA
import Html.Events as HE
import Keyboard
import Time
import Window


-- LOCAL IMPORTS

import Phrase.Model as Phrase
import Phrase.Update as Phrase
import Phrase.View as Phrase
import Picture.Model as Picture
import Picture.Update as Picture
import Picture.View as Picture
import Words.Model as Words
import Words.Update as Words


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
    , incorrectLettersGuessed : List Char
    , windowWidth : Int
    , windowHeight : Int
    , gameStatus : GameStatus
    , animationStep : Time.Time
    }


initModel : Model
initModel =
    { phrase = ""
    , letters = []
    , allowedIncorrectGuesses = 7
    , incorrectGuesses = 0
    , correctGuesses = 0
    , incorrectLettersGuessed = []
    , windowWidth = 0
    , windowHeight = 0
    , gameStatus = InProcess
    , animationStep = 0.0
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
    | WordsMsg Words.Msg
    | NewGame


initGame : ( Model, Cmd Msg )
initGame =
    let
        ( wrdsModel, wrdsCmd ) =
            Words.Init
                |> WordsMsg
                |> flip update initModel

    in
        ( wrdsModel, Cmd.batch [ wrdsCmd ] )


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
                statusModel =
                    if phrModel.incorrectGuesses >= phrModel.allowedIncorrectGuesses then
                        { phrModel | gameStatus = Lost }
                    else if Phrase.numLettersLeft phrModel.letters == 0 then
                        { phrModel | gameStatus = Won }
                    else
                        phrModel

                ( newModel, newCmd ) =
                    case msg of
                        Phrase.InitDone ->
                            -- The Phrase component is done initializing, now
                            -- initialize the Picture component.
                            Picture.Init
                                |> PictureMsg
                                |> flip update statusModel

                        _ ->
                            ( statusModel, Cmd.map PhraseMsg phrCmd )
            in
                ( newModel, newCmd )

        PictureMsg msg ->
            let
                ( picModel, picCmd ) =
                    Picture.update msg model
            in
                ( picModel, Cmd.map PictureMsg picCmd )

        WordsMsg msg ->
            let
                ( wrdsModel, wrdsCmd ) =
                    Words.update msg model

                ( newModel, newCmd ) =
                    case msg of
                        Words.InitDone ->
                            -- The Words component is done initializing, now
                            -- initialize the Phrase component.
                            Phrase.Init wrdsModel.phrase 7
                                |> PhraseMsg
                                |> flip update wrdsModel

                        _ ->
                            ( wrdsModel, Cmd.map WordsMsg wrdsCmd )
            in
                ( newModel, newCmd )

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
                , Html.div [ marginStyle ]
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
                    , Sub.map PictureMsg (AF.diffs Picture.AnimationStep)
                    ]
            else
                Sub.none
    in
        subs
