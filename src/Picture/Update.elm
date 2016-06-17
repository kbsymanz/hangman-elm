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
            ( { model | incorrectGuesses = model.incorrectGuesses + 1 }, Cmd.none )

        WindowResize size ->
            ( { model | windowWidth = size.width, windowHeight = size.height }, Cmd.none )
