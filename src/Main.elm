module Main exposing (..)

import Html exposing (Html)
import Element
import Element.Attributes
import Style
import Style.Color
import Style.Font
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
    = None
    | Main
    | Header


stylesheet =
    Style.styleSheet
        [ Style.style Main
            []
        , Style.style Header
            [ Style.Color.background (Color.rgb 39 48 67)
            , Style.Color.text (Color.white)
            , Style.Font.typeface [ Style.Font.font "Barlow Condensed" ]
            , Style.Font.size 20
            , Style.Font.uppercase
            ]
        ]


view : Model -> Html Msg
view model =
    Element.layout stylesheet <|
        Element.column Main
            []
            [ viewHeader ]


viewHeader =
    Element.el Header
        [ Element.Attributes.height (Element.Attributes.px 60)
        , Element.Attributes.width (Element.Attributes.fill)
        ]
        (Element.el None
            [ Element.Attributes.center
            , Element.Attributes.verticalCenter
            ]
            (Element.text
                "Övningar"
            )
        )
        |> Element.screen
