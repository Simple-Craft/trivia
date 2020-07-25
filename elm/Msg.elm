module Msg exposing (Msg(..))

import Browser
import Http
import Model exposing (User)
import Url


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | LoadedUserData (Result Http.Error User)
