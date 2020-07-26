module Page.List exposing (Model, Msg(..), init, update, view)

import Html


type alias Model =
    {}


type Msg
    = NoOp


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )


view : Model -> List (Html.Html msg)
view _ =
    [ Html.text "List" ]
