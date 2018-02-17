module StopWatch exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Time exposing (Time)


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
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Tick time ->
            { model | currentTime = time }

        Start ->
            { model | state = Running (model.currentTime) }

        Reset ->
            { model | state = NotRunning }


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (100 * Time.millisecond) Tick


view : Model -> Html Msg
view model =
    div []
        [ viewTime model
        , if model.state == NotRunning then
            button [ onClick Start ] [ text "Start" ]
          else
            button [ onClick Reset ] [ text "Reset" ]
        ]


viewTime : Model -> Html Msg
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
