module Phrase.View exposing (..)

import Char
import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE exposing (onClick)
import Set
import String


-- LOCAL IMPORTS

import Phrase.Model exposing (Model, Letter, LetterStatus(..))
import Phrase.Update exposing (..)


(=>) =
    (,)


statsDiv : H.Attribute a
statsDiv =
    HA.style []


outerDiv : H.Attribute a
outerDiv =
    HA.style
        [ "margin" => "20px"
        , "border" => "2px solid #e9e9e9"
        , "padding" => "10px"
        , "padding-bottom" => "30px"
        ]


letterDiv : H.Attribute a
letterDiv =
    HA.style
        [ "margin-top" => "20px"
        ]


letterStyle : H.Attribute a
letterStyle =
    HA.style
        [ "background" => "#e9e9e9"
        , "color" => "#e9e9e9"
        , "padding" => "10px"
        , "margin" => "10px 5px"
        , "border-bottom" => "2px solid black"
        , "line-height" => "3.5"
        ]


letterStyleSpace : H.Attribute a
letterStyleSpace =
    HA.style
        [ "background" => "white"
        , "padding" => "10px"
        , "margin" => "10px 5px"
        ]


letterStyleGuessed : H.Attribute a
letterStyleGuessed =
    HA.style
        [ "background" => "#e9e9e9"
        , "color" => "green"
        , "padding" => "10px"
        , "margin" => "10px 5px"
        , "border-bottom" => "10px solid green"
        , "line-height" => "3.5"
        ]


viewStatStyle : H.Attribute a
viewStatStyle =
    HA.style
        [ "color" => "#696969"
        , "font-size" => "120%"
        ]


viewStat : String -> String -> Html a
viewStat statName statValue =
    H.div [ viewStatStyle ]
        [ H.text (statName ++ ": " ++ statValue) ]


viewLetter : Letter -> Html a
viewLetter ltr =
    let
        -- Do not reveal letter if not guessed.
        char =
            if .guessed ltr /= Guessed then
                ' '
            else
                .char ltr

        style =
            if .guessed ltr == Guessed && char /= ' ' then
                letterStyleGuessed
            else if .guessed ltr == Guessed && char == ' ' then
                letterStyleSpace
            else
                letterStyle
    in
        H.span [ style ]
            [ char |> String.fromChar |> H.text ]


view : Model a -> Html Msg
view model =
    let
        allowedInc =
            toString model.allowedIncorrectGuesses
    in
        H.div [ outerDiv ]
            [ H.div [ statsDiv ]
                [ H.div [ viewStatStyle ]
                    [ H.text ("You are allowed " ++ allowedInc ++ " misses. Guessing incorrectly counts as a miss.") ]
                , viewStat "Incorrectly Guessed" (toString model.incorrectGuesses)
                , viewStat "Correctly Guessed" (toString model.correctGuesses)
                , List.map String.fromChar model.incorrectLettersGuessed
                    |> List.sort
                    |> String.join " "
                    |> viewStat "Incorrect Letters"
                ]
            , H.div [ letterDiv ]
                (List.map viewLetter model.letters)
            ]
