module Picture.Update exposing (..)

import Task
import Window


-- LOCAL IMPORTS

import Picture.Model exposing (Model)


-- UPDATE


type Msg
    = NoOp
    | Init
    | Incorrect Int
    | WindowResize Window.Size
    | InitDone


getWindowSize : Cmd Msg
getWindowSize =
    Task.perform (always NoOp) WindowResize Window.size


update : Msg -> Model a -> ( Model a, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Init ->
            ( model, getWindowSize )

        Incorrect _ ->
            -- Incorrect is used for testing the Picture component stand-alone
            -- by responding to key presses in order to move the picture along.
            ( { model | incorrectGuesses = model.incorrectGuesses + 1 }, Cmd.none )

        WindowResize size ->
            let
                newModel =
                    { model | windowWidth = size.width, windowHeight = size.height }
            in
                update InitDone newModel

        InitDone ->
            ( model, Cmd.none )
