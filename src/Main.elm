module Main exposing (..)

import Html exposing (Html)
import View


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = always Sub.none
        , update = update
        , view = View.view
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
