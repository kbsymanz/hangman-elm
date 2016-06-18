module Words.Update exposing (..)

import Array
import Random

-- LOCAL IMPORTS

import Words.Model as Words exposing (Model, words)


type Msg
    = NoOp
    | GenWord
    | NewWord Int


update : Msg -> Model a -> ( Model a, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GenWord ->
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
                            model.nextWord
            in
                ( { model | nextWord = word }, Cmd.none )
