module Phrase.View exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE exposing (onClick)
import String


-- LOCAL IMPORTS

import Phrase.Model exposing (Model, Letter, GameStatus(..), LetterStatus(..))
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
        ]


letterDiv : H.Attribute a
letterDiv =
    HA.style
        [ "margin-top" => "20px"
        ]


gameOverDiv : H.Attribute a
gameOverDiv =
    HA.style
        [ "font-size" => "200%"
        , "font-weight" => "bold"
        , "color" => "black"
        , "margin" => "10px 0"
        , "padding-top" => "20px"
        ]


gameNotOverDiv : H.Attribute a
gameNotOverDiv =
    HA.style
        [ "font-size" => "200%"
        , "font-weight" => "bold"
        , "color" => "white"
        , "margin" => "10px 0"
        , "padding-top" => "20px"
        ]


letterStyle : H.Attribute a
letterStyle =
    HA.style
        [ "background" => "#e9e9e9"
        , "color" => "#e9e9e9"
        , "padding" => "10px"
        , "margin" => "10px 5px"
        , "border-bottom" => "2px solid black"
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
        , "padding" => "10px"
        , "margin" => "10px 5px"
        , "border-bottom" => "10px solid green"
        , "color" => "green"
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
        char =
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

        ( gameOverStyle, gameOverMsg ) =
            case model.gameStatus of
                InProcess ->
                    ( gameNotOverDiv, "" )

                Won ->
                    ( gameOverDiv, " - You WON!" )

                Lost ->
                    ( gameOverDiv, " - sorry, you lost" )
    in
        H.div [ outerDiv ]
            [ H.div [ statsDiv ]
                [ H.div [ viewStatStyle ]
                    [ H.text ("You are allowed " ++ allowedInc ++ " misses. Guessing incorrectly counts as a miss.") ]
                , viewStat "Incorrectly Guessed" (toString model.incorrectGuesses)
                , viewStat "Correctly Guessed" (toString model.correctGuesses)
                ]
            , H.div [ letterDiv ]
                (List.map viewLetter model.letters)
            , H.div [ gameOverStyle ]
                [ H.text ("Game Over" ++ " " ++ gameOverMsg) ]
            ]
