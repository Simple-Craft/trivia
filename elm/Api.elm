module Api exposing (getUserData, handleGetUserData)

import Http
import HttpBuilder
import Model exposing (Model, User, decodeUser)
import Msg exposing (Msg(..))


getUserData : Cmd Msg
getUserData =
    "/user/me/"
        |> HttpBuilder.get
        |> HttpBuilder.withTimeout 1000
        |> HttpBuilder.withExpect (Http.expectJson LoadedUserData decodeUser)
        |> HttpBuilder.request


handleGetUserData : Model -> Result Http.Error User -> ( Model, Cmd Msg )
handleGetUserData model result =
    case result of
        Err _ ->
            ( model, Cmd.none )

        Ok user ->
            ( { model | user = Just user }, Cmd.none )
