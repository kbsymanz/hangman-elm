module Picture.View exposing (..)

import Html as H exposing (Html)
import String
import Svg as S
import Svg.Attributes as S
import Time


-- LOCAL IMPORTS

import Picture.Model exposing (Model)
import Picture.Update exposing (Msg(..))


-- VIEW


moon : Time.Time -> Html a
moon step =
    S.g
        []
        [ S.circle
            [ S.cx (toString (step - 40))
            , S.cy "30"
            , S.r "20"
            , S.stroke "white"
            , S.fill "white"
            , S.strokeWidth "4"
            ]
            []
        ]


gallows : Html a
gallows =
    S.g
        [ S.stroke "white"
        , S.strokeWidth "6"
        ]
        [ S.line
            -- Vertical main pole.
            [ S.x1 "80"
            , S.y1 "262"
            , S.x2 "80"
            , S.y2 "80"
            ]
            []
        , S.line
            -- Left brace.
            [ S.x1 "40"
            , S.y1 "265"
            , S.x2 "80"
            , S.y2 "230"
            ]
            []
        , S.line
            -- Right brace.
            [ S.x1 "120"
            , S.y1 "262"
            , S.x2 "80"
            , S.y2 "230"
            ]
            []
        , S.line
            -- Top cross-beam.
            [ S.x1 "77"
            , S.y1 "80"
            , S.x2 "150"
            , S.y2 "80"
            ]
            []
        , S.line
            -- Top down beam.
            [ S.x1 "150"
            , S.y1 "70"
            , S.x2 "150"
            , S.y2 "100"
            ]
            []
        ]


background : Int -> Int -> Html a
background w h =
    S.g []
        [ S.rect
            [ S.width (intToPx w)
            , S.height (intToPx h)
            ]
            []
        , S.ellipse
            [ S.cx (intToPx (w // 2))
            , S.cy (intToPx h)
            , S.rx (intToPx w)
            , S.ry (intToPx (h // 10))
            , S.fill "green"
            ]
            []
        ]


head : Html a
head =
    S.circle
        [ S.cx "150"
        , S.cy "115"
        , S.r "15"
        , S.stroke "white"
        , S.strokeWidth "2"
        ]
        []


face : Html a
face =
    S.svg
        [ S.stroke "white"
        , S.strokeWidth "1"
        , S.x "135"
        , S.y "100"
        , S.width "30"
        , S.height "30"
        ]
        [ S.line
            [ S.x1 "7"
            , S.y1 "10"
            , S.x2 "13"
            , S.y2 "13"
            ]
            []
        , S.line
            [ S.x1 "13"
            , S.y1 "10"
            , S.x2 "7"
            , S.y2 "13"
            ]
            []
        , S.line
            [ S.x1 "17"
            , S.y1 "10"
            , S.x2 "23"
            , S.y2 "13"
            ]
            []
        , S.line
            [ S.x1 "23"
            , S.y1 "10"
            , S.x2 "17"
            , S.y2 "13"
            ]
            []
        , S.ellipse
            [ S.cx "15"
            , S.cy "20"
            , S.rx "3"
            , S.ry "5"
            ]
            []
        ]


body : Html a
body =
    S.line
        [ S.x1 "150"
        , S.y1 "130"
        , S.x2 "150"
        , S.y2 "180"
        , S.strokeWidth "2"
        , S.stroke "white"
        ]
        []


leftArm : Html a
leftArm =
    S.line
        [ S.x1 "150"
        , S.y1 "140"
        , S.x2 "120"
        , S.y2 "160"
        , S.strokeWidth "2"
        , S.stroke "white"
        ]
        []


rightArm : Html a
rightArm =
    S.line
        [ S.x1 "150"
        , S.y1 "140"
        , S.x2 "180"
        , S.y2 "160"
        , S.strokeWidth "2"
        , S.stroke "white"
        ]
        []


leftLeg : Html a
leftLeg =
    S.line
        [ S.x1 "150"
        , S.y1 "180"
        , S.x2 "120"
        , S.y2 "220"
        , S.strokeWidth "2"
        , S.stroke "white"
        ]
        []


rightLeg : Html a
rightLeg =
    S.line
        [ S.x1 "150"
        , S.y1 "180"
        , S.x2 "180"
        , S.y2 "220"
        , S.strokeWidth "2"
        , S.stroke "white"
        ]
        []


intToPx : Int -> String
intToPx int =
    int |> toString |> flip (++) "px"


view : Model a -> Html Msg
view model =
    let
        svgWidth =
            model.windowWidth // 2

        svgHeight =
            svgWidth

        bodyParts =
            [ (moon model.animationStep), gallows, head, body, leftArm, rightArm, leftLeg, rightLeg, face ]

        shownBody =
            List.take (model.incorrectGuesses + 2) bodyParts
    in
        S.svg
            [ S.width (intToPx svgWidth)
            , S.height (intToPx svgHeight)
            ]
            [ background svgWidth svgHeight
            , S.svg
                [ S.width (intToPx svgWidth)
                , S.height (intToPx svgHeight)
                ]
                [ S.svg
                    [ S.viewBox "0 0 290 290"
                    ]
                    shownBody
                ]
            ]
