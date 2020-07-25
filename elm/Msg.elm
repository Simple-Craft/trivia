module Msg exposing (Msg(..))

import Browser
import Http
import Model exposing (User)
import Page.Create as Create
import Page.List as List
import Page.Queue as Queue
import Url


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | LoadedUserData (Result Http.Error User)
    | QueueMsg Queue.Msg
    | CreateMsg Create.Msg
    | ListMsg List.Msg
