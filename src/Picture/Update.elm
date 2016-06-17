module Picture.Update exposing (..)

import Task
import Window


-- LOCAL IMPORTS

import Picture.Model exposing (Model)


-- UPDATE


type Msg
    = NoOp
    | InitGame
    | Incorrect Int
    | WindowResize Window.Size


getWindowSize : Cmd Msg
getWindowSize =
    Task.perform (always NoOp) WindowResize Window.size


update : Msg -> Model a -> ( Model a, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        InitGame ->
            ( model, getWindowSize )

        Incorrect _ ->
            -- Incorrect is used for testing the Picture component stand-alone.
            ( { model | incorrectGuesses = model.incorrectGuesses + 1 }, Cmd.none )

        WindowResize size ->
            ( { model | windowWidth = size.width, windowHeight = size.height }, Cmd.none )
