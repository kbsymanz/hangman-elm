module Phrase.Update exposing (..)

import Char
import Keyboard
import Set
import String
import Task


-- LOCAL IMPORTS

import Phrase.Model exposing (Model, Letter, LetterStatus(..))


type Msg
    = Init String Int
    | Keypress Keyboard.KeyCode
    | InitDone


{-| Return the number of letters that are left unguessed.
-}
numLettersLeft : List Letter -> Int
numLettersLeft letters =
    letters
        |> List.filter (\ltr -> ltr.guessed == Unguessed)
        |> List.map .char
        |> Set.fromList
        |> Set.size


{-| Searches the list of Letters for a match against the Char
    passed, updates any matching Letters, and returns a tuple
    signifying if there were any matches and the new List
    of Letters. The match is done with case insensitivity.
-}
updateLetters : Char -> List Letter -> ( Bool, List Letter )
updateLetters c letters =
    let
        found =
            List.map .char letters
                |> List.map Char.toLower
                |> List.any ((==) (Char.toLower c))

        newLetters =
            letters
                |> List.map
                    (\ltr ->
                        if Char.toLower ltr.char == Char.toLower c then
                            { ltr | guessed = Guessed }
                        else
                            ltr
                    )
    in
        ( found, newLetters )


{-| Create a List Letter from a String passed.
-}
initLetters : String -> List Letter
initLetters phrase =
    phrase
        |> String.toList
        |> List.map
            (\c ->
                Letter c
                    (if c == ' ' then
                        Guessed
                     else
                        Unguessed
                    )
            )


doInitDone : Cmd Msg
doInitDone =
    Task.perform (always InitDone) (always InitDone) (Task.succeed "")


update : Msg -> Model a -> ( Model a, Cmd Msg )
update msg model =
    case msg of
        Init phrase allowedIncorrectGuesses ->
            let
                newModel =
                    { model
                        | phrase = phrase
                        , letters = initLetters phrase
                        , allowedIncorrectGuesses = allowedIncorrectGuesses
                        , incorrectGuesses = 0
                        , correctGuesses = 0
                    }
            in
                ( newModel, doInitDone )

        Keypress kc ->
            let
                char =
                    Char.fromCode kc

                upperChar =
                    Char.toUpper char

                origNumLeft =
                    numLettersLeft model.letters

                origIncorrect =
                    List.length model.incorrectLettersGuessed

                ( found, letters ) =
                    updateLetters char model.letters

                newNumLeft =
                    numLettersLeft letters

                -- Account for user pressing correct letter more than once.
                correct =
                    if found && newNumLeft < origNumLeft then
                        model.correctGuesses + 1
                    else
                        model.correctGuesses

                incorrectLettersGuessed =
                    if not found then
                        model.incorrectLettersGuessed
                            ++ [ upperChar ]
                            |> Set.fromList
                            |> Set.toList
                    else
                        model.incorrectLettersGuessed

                -- Only count new incorrect letters as incorrect.
                incorrect =
                    if List.length incorrectLettersGuessed > origIncorrect then
                        model.incorrectGuesses + 1
                    else
                        model.incorrectGuesses
            in
                ( { model
                    | letters = letters
                    , incorrectGuesses = incorrect
                    , correctGuesses = correct
                    , incorrectLettersGuessed = incorrectLettersGuessed
                  }
                , Cmd.none
                )

        InitDone ->
            ( model, Cmd.none )
