module Main exposing (..)

import Html exposing (Html)
import Element.Events exposing (onClick)
import Element exposing (..)
import Element.Attributes as Attributes exposing (..)
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


type StyleId
    = None
    | Header
    | TabBar
    | TabSelected
    | ListItem


stylesheet : StyleSheet StyleId a
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
        layout stylesheet <|
            column None
                []
                views


viewBody : Model -> Element StyleId b Msg
viewBody model =
    let
        viewItem item =
            text item
                |> el ListItem
                    [ padding 15
                    , onClick (ChangePage Exercise)
                    ]
    in
        List.map viewItem model.exercises
            |> column None [ paddingTop 60, paddingBottom 60 ]


viewHeader : String -> Element StyleId b c
viewHeader headerText =
    el Header
        [ height (px 60)
        , width fill
        ]
        (el None
            [ center
            , verticalCenter
            ]
            (text headerText)
        )
        |> screen


viewTabBar : Model -> Element StyleId b Msg
viewTabBar model =
    el TabBar
        [ height (px 60)
        , width fill
        , alignBottom
        ]
        (row None
            [ height fill ]
            [ viewTab "Övningar" Exercises model.currentPage
            , viewTab "Pass" Workouts model.currentPage
            , viewTab "Stoppur" StopWatch model.currentPage
            ]
        )
        |> screen


viewTab : String -> Page -> Page -> Element StyleId b Msg
viewTab title thisPage currentPage =
    el
        (if thisPage == currentPage then
            TabSelected
         else
            None
        )
        [ width fill
        , onClick (ChangePage thisPage)
        ]
        (el None
            [ center
            , verticalCenter
            ]
            (text title)
        )
