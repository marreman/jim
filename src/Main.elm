module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import StopWatch


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
                        Html.map StopWatchMsg
                            (StopWatch.view model.stopWatch)
                    , viewTabBar model
                    ]

                Exercise ->
                    [ viewHeader "Övning"
                    , viewTabBar model
                    ]
    in
        div [] views


viewBody : Html Msg -> Html Msg
viewBody contents =
    div [] [ contents ]


viewList : Model -> Html Msg
viewList model =
    let
        viewItem item =
            div [] [ text item ]
    in
        div [] <|
            List.map viewItem model.exercises


viewHeader : String -> Html Msg
viewHeader headerText =
    text headerText


viewTabBar : Model -> Html Msg
viewTabBar model =
    div []
        [ viewTab "Övningar" Exercises model.currentPage
        , viewTab "Pass" Workouts model.currentPage
        , viewTab "Stoppur" StopWatch model.currentPage
        ]


viewTab : String -> Page -> Page -> Html Msg
viewTab title thisPage currentPage =
    button [ onClick (ChangePage thisPage) ] [ text title ]
