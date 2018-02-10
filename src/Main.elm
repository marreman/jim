module Main exposing (..)

import Html exposing (Html)
import Element
import Style
import Style.Color
import Color


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = always Sub.none
        , update = update
        , view = view
        }


type alias Model =
    { exercises : List String }


init : ( Model, Cmd Msg )
init =
    ( { exercises =
            [ "Knäböj"
            , "Marklyft"
            ]
      }
    , Cmd.none
    )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


type Class
    = Main


stylesheet =
    Style.styleSheet
        [ Style.style Main
            [ Style.Color.text Color.grey
            ]
        ]


view : Model -> Html Msg
view model =
    Element.layout stylesheet <|
        Element.el Main
            []
            (Element.text
                "Welcome to Jim!"
            )
