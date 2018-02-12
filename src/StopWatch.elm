module StopWatch exposing (init, Model, Msg, update, subscriptions, view, styles)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Color
import Time exposing (Time)
import StyleId exposing (..)


type alias Model =
    { currentTime : Time
    , state : StopWatchState
    }


type StopWatchState
    = NotRunning
    | Running Time


init : ( Model, Cmd msg )
init =
    ( { currentTime = 0, state = NotRunning }, Cmd.none )


type Msg
    = Tick Time
    | Start


update : Msg -> Model -> Model
update msg model =
    case msg of
        Tick time ->
            { model | currentTime = time }

        Start ->
            { model | state = Running (model.currentTime) }


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (100 * Time.millisecond) Tick


styles =
    [ style StopWatch
        [ Font.typeface [ Font.font "Barlow Condensed" ]
        , Font.size 32
        ]
    ]


view : Model -> Element StyleId b Msg
view model =
    column StopWatch
        [ height fill
        , width fill
        , onClick Start
        , center
        , verticalCenter
        ]
        [ el Time [ padding 60 ] (viewTime model)
        , button None
            [ onClick Start ]
            (text "Start")
        ]


viewTime model =
    text <|
        case model.state of
            NotRunning ->
                "0"

            Running startTime ->
                (model.currentTime - startTime)
                    |> Time.inSeconds
                    |> round
                    |> toString
