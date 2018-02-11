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
    = Exercises
    | Workouts
    | StopWatch
    | Exercise


init : ( Model, Cmd Msg )
init =
    ( { currentPage = Exercises
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
    | TabBar
    | TabSelected
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
        , style TabBar
            [ Color.background (Color.grey)
            , Font.typeface [ Font.font "Barlow Condensed" ]
            , Font.size 22
            , Font.uppercase
            ]
        , style TabSelected
            [ Color.background (Color.rgb 39 48 67)
            , Color.text Color.white
            ]
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
                Exercises ->
                    [ viewHeader "Övningar"
                    , viewBody model
                    , viewTabBar model
                    ]

                Workouts ->
                    [ viewHeader "Pass"
                    , viewTabBar model
                    ]

                StopWatch ->
                    [ viewHeader "Stoppur"
                    , viewTabBar model
                    ]

                Exercise ->
                    [ viewHeader "Övning"
                    , viewBody model
                    , viewTabBar model
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
                    , onClick (ChangePage Exercise)
                    ]
    in
        List.map viewItem model.exercises
            |> El.column None [ At.paddingTop 60, At.paddingBottom 60 ]


viewHeader : String -> El.Element Class b c
viewHeader headerText =
    El.el Header
        [ At.height (At.px 60)
        , At.width At.fill
        ]
        (El.el None
            [ At.center
            , At.verticalCenter
            ]
            (El.text headerText)
        )
        |> El.screen


viewTabBar : Model -> El.Element Class b Msg
viewTabBar model =
    El.el TabBar
        [ At.height (At.px 60)
        , At.width At.fill
        , At.alignBottom
        ]
        (El.row None
            [ At.height At.fill ]
            [ viewTab "Övningar" Exercises model.currentPage
            , viewTab "Pass" Workouts model.currentPage
            , viewTab "Stoppur" StopWatch model.currentPage
            ]
        )
        |> El.screen


viewTab : String -> Page -> Page -> El.Element Class b Msg
viewTab title thisPage currentPage =
    El.el
        (if thisPage == currentPage then
            TabSelected
         else
            None
        )
        [ At.width At.fill
        , onClick (ChangePage thisPage)
        ]
        (El.el None
            [ At.center
            , At.verticalCenter
            ]
            (El.text title)
        )
