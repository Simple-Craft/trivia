module Main exposing (init, main, subscriptions)

import Browser
import Browser.Navigation as Nav
import Model exposing (Model, Page(..))
import Msg exposing (Msg(..))
import Update exposing (getUserData, router, update)
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
init _ url key =
    let
        ( model, cmd ) =
            router url
                { key = key
                , user = Nothing
                , page = Index
                }
    in
    ( model, Cmd.batch [ cmd, getUserData ] )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = "Trivia DB"
    , body = view model
    }
