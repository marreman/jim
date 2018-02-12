module Main exposing (..)

import Html exposing (Html)
import Element.Events exposing (onClick)
import Element exposing (..)
import Element.Attributes as Attributes exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Style.Border as Border
import Style.Sheet
import Color
import StopWatch
import StyleId exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type alias Model =
    { exercises : List String
    , currentPage : Page
    , stopWatch : StopWatch.Model
    }


type Page
    = Exercises
    | Workouts
    | StopWatch
    | Exercise


init : ( Model, Cmd Msg )
init =
    ( { currentPage = StopWatch
      , exercises =
            [ "Knäböj"
            , "Marklyft"
            ]
      , stopWatch = Tuple.first StopWatch.init
      }
    , Cmd.none
    )


type Msg
    = ChangePage Page
    | StopWatchMsg StopWatch.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangePage page ->
            ( { model | currentPage = page }, Cmd.none )

        StopWatchMsg stopWatchMsg ->
            ( { model
                | stopWatch = StopWatch.update stopWatchMsg model.stopWatch
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map StopWatchMsg (StopWatch.subscriptions model.stopWatch)


stylesheet : StyleSheet StyleId a
stylesheet =
    styleSheet <|
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
            ++ StopWatch.styles


view : Model -> Html Msg
view model =
    let
        views =
            case model.currentPage of
                Exercises ->
                    [ viewHeader "Övningar"
                    , viewBody (viewList model)
                    , viewTabBar model
                    ]

                Workouts ->
                    [ viewHeader "Pass"
                    , viewTabBar model
                    ]

                StopWatch ->
                    [ viewHeader "Stoppur"
                    , viewBody <|
                        Element.map StopWatchMsg
                            (StopWatch.view model.stopWatch)
                    , viewTabBar model
                    ]

                Exercise ->
                    [ viewHeader "Övning"
                    , viewTabBar model
                    ]
    in
        layout stylesheet <|
            column None
                [ height fill ]
                views


viewBody : Element StyleId b Msg -> Element StyleId b Msg
viewBody =
    el None [ height fill, paddingTop 60, paddingBottom 60 ]


viewList : Model -> Element StyleId b Msg
viewList model =
    let
        viewItem item =
            text item
                |> el ListItem
                    [ padding 15
                    , onClick (ChangePage Exercise)
                    ]
    in
        column None [] <|
            List.map viewItem model.exercises


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
