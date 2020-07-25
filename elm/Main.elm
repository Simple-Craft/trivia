module Main exposing (init, subscriptions)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Model exposing (Model)
import Update exposing (Msg(..), update)
import Url
import View exposing (view)


type alias Flags =
    {}


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = viewDocument
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        model =
            { url = url
            , key = key
            }

        _ =
            Debug.log "Initialized!" model
    in
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = "Trivia DB"
    , body = view model
    }
