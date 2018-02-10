module View exposing (..)

import Element as El
import Element.Attributes as At
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Color


type Class
    = None
    | Header


stylesheet =
    styleSheet
        [ style Header
            [ Color.background (Color.rgb 39 48 67)
            , Color.text (Color.white)
            , Font.typeface [ Font.font "Barlow Condensed" ]
            , Font.size 20
            , Font.uppercase
            ]
        ]


view model =
    El.layout stylesheet <|
        El.column None
            []
            [ viewHeader ]


viewHeader =
    El.el Header
        [ At.height (At.px 60)
        , At.width At.fill
        ]
        (El.el None
            [ At.center
            , At.verticalCenter
            ]
            (El.text
                "Övningar"
            )
        )
        |> El.screen
