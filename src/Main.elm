module Main exposing (..)

import Html exposing (Html)
import Element.Events exposing (onClick)
import Element as El
import Element.Attributes as At
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Style.Border as Border
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
    { exercises : List String
    , currentPage : Page
    }


type Page
    = Exercises PageInfo
    | Exercise PageInfo


type alias PageInfo =
    { title : String
    }


init : ( Model, Cmd Msg )
init =
    ( { currentPage = Exercises { title = "Övningar" }
      , exercises =
            [ "Knäböj"
            , "Marklyft"
            , "Marklyft"
            , "Marklyft"
            , "Marklyft"
            , "Marklyft"
            , "Marklyft"
            , "Marklyft"
            , "Marklyft"
            , "Marklyft"
            , "Marklyft"
            , "Marklyft"
            ]
      }
    , Cmd.none
    )


type Msg
    = ChangePage Page


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangePage page ->
            ( { model | currentPage = page }, Cmd.none )


type Class
    = None
    | Header
    | Body
    | ListItem


stylesheet =
    styleSheet
        [ style Header
            [ Color.background (Color.rgb 39 48 67)
            , Color.text (Color.white)
            , Font.typeface [ Font.font "Barlow Condensed" ]
            , Font.size 22
            , Font.uppercase
            ]
        , style Body
            []
        , style ListItem
            [ Font.typeface [ Font.font "Barlow Condensed" ]
            , Font.size 20
            , Border.bottom 1
            , Color.border (Color.rgb 230 230 230)
            ]
        ]


view : Model -> Html Msg
view model =
    let
        views =
            case model.currentPage of
                Exercises info ->
                    [ viewHeader info
                    , viewBody model
                    ]

                Exercise info ->
                    [ viewHeader info
                    , viewBody model
                    ]
    in
        El.layout stylesheet <|
            El.column None
                []
                views


viewBody : Model -> El.Element Class b Msg
viewBody model =
    let
        viewItem item =
            El.text item
                |> El.el ListItem
                    [ At.padding 15
                    , onClick (ChangePage (Exercise { title = item }))
                    ]
    in
        List.map viewItem model.exercises
            |> El.column Body [ At.paddingTop 60 ]


viewHeader : PageInfo -> El.Element Class b c
viewHeader info =
    El.el Header
        [ At.height (At.px 60)
        , At.width At.fill
        ]
        (El.el None
            [ At.center
            , At.verticalCenter
            ]
            (El.text
                info.title
            )
        )
        |> El.screen
