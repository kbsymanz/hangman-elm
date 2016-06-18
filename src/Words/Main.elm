module Words.Main exposing (..)

import Html exposing (Html)
import Html.App as Html
import Time


-- LOCAL IMPORTS

import Words.Model as Words exposing (Model)
import Words.Update as Words exposing (Msg(..))


main =
    Html.program
        { init = Words.update GenWord Words.initialModel
        , view = view
        , update = Words.update
        , subscriptions = subscriptions
        }


{-| Testing only
-}
view : Model a -> Html Msg
view model =
    Html.div []
        [ Html.text model.nextWord ]


subscriptions : Model a -> Sub Msg
subscriptions model =
    Time.every Time.second (always GenWord)
