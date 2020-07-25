module Model exposing (Model, User, decodeUser)

import Browser.Navigation as Nav
import Json.Decode as Decode exposing (bool, string)
import Json.Decode.Pipeline exposing (required)
import Url


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , user : Maybe User
    , tablePage : Int
    }


type alias User =
    { discordId : String
    , username : String
    , admin : Bool
    }


decodeUser : Decode.Decoder User
decodeUser =
    Decode.succeed User
        |> required "discordId" string
        |> required "username" string
        |> required "admin" bool
