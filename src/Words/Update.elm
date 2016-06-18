module Words.Update exposing (..)

import Array
import Random
import Task


-- LOCAL IMPORTS

import Words.Model as Words exposing (Model, words)


type Msg
    = Init
    | NewWord Int
    | InitDone


doInitDone : Cmd Msg
doInitDone =
    Task.perform (always InitDone) (always InitDone) (Task.succeed "")


update : Msg -> Model a -> ( Model a, Cmd Msg )
update msg model =
    case msg of
        Init ->
            ( model, Random.generate NewWord (Random.int 0 (List.length words)) )

        NewWord idx ->
            let
                maybeWord =
                    words
                        |> Array.fromList
                        |> Array.get idx

                word =
                    case maybeWord of
                        Just w ->
                            w

                        Nothing ->
                            model.phrase
            in
                ( { model | phrase = word }, doInitDone )

        InitDone ->
            ( model, Cmd.none )
