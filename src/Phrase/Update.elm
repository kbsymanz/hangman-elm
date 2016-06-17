module Phrase.Update exposing (..)

import Char
import Keyboard
import Set
import String


-- LOCAL IMPORTS

import Phrase.Model exposing (Model, Letter, LetterStatus(..))


type Msg
    = InitGame String Int
    | Keypress Keyboard.KeyCode


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
    of Letters.
-}
updateLetters : Char -> List Letter -> ( Bool, List Letter )
updateLetters c letters =
    let
        found =
            List.map .char letters
                |> List.any ((==) c)

        newLetters =
            letters
                |> List.map
                    (\ltr ->
                        if ltr.char == c then
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


update : Msg -> Model a -> ( Model a, Cmd Msg )
update msg model =
    case msg of
        InitGame phrase allowedIncorrectGuesses ->
            ( { model
                | phrase = phrase
                , letters = initLetters phrase
                , allowedIncorrectGuesses = allowedIncorrectGuesses
                , incorrectGuesses = 0
                , correctGuesses = 0
              }
            , Cmd.none
            )

        Keypress kc ->
            let
                origNumLeft =
                    numLettersLeft model.letters

                ( found, letters ) =
                    updateLetters (Char.fromCode kc) model.letters

                newNumLeft =
                    numLettersLeft letters

                -- Account for user pressing correct letter more than once.
                ( correct, incorrect ) =
                    if found && newNumLeft < origNumLeft then
                        ( model.correctGuesses + 1, model.incorrectGuesses )
                    else if found then
                        ( model.correctGuesses, model.incorrectGuesses )
                    else
                        ( model.correctGuesses, model.incorrectGuesses + 1 )

            in
                ( { model
                    | letters = letters
                    , incorrectGuesses = incorrect
                    , correctGuesses = correct
                  }
                , Cmd.none
                )


