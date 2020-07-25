module Update exposing (update)

import Api
import Browser
import Browser.Navigation as Nav
import Model exposing (Model)
import Msg exposing (Msg(..))
import Url


internalRedirections : List String
internalRedirections =
    [ "/user/login"
    ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    let
                        urlString =
                            Url.toString url
                    in
                    if List.any ((==) url.path) internalRedirections then
                        ( model, Nav.load urlString )

                    else
                        ( model, Nav.pushUrl model.key urlString )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        LoadedUserData result ->
            Api.handleGetUserData model result
