module Model exposing (Model, Page(..), User, decodeUser)

import Browser.Navigation as Nav
import Json.Decode as Decode exposing (bool, string)
import Json.Decode.Pipeline exposing (required)
import Page.Create as Create
import Page.List as List
import Page.Queue as Queue
import Url


type alias Model =
    { key : Nav.Key
    , user : Maybe User
    , page : Page
    }


type alias User =
    { discordId : String
    , username : String
    , admin : Bool
    }


type Page
    = Index
    | Queue Queue.Model
    | Create Create.Model
    | List List.Model


decodeUser : Decode.Decoder User
decodeUser =
    Decode.succeed User
        |> required "discordId" string
        |> required "username" string
        |> required "admin" bool
