module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, id, href)
import Model exposing (Model)


viewHeader : Html msg
viewHeader =
    div [ class "header" ]
        [ h1 [] [ text "Trivia DB" ]
        , div [ class "header-right" ]
            [ a [ class "button", href "/user/login" ] [ text "Login" ]
            ]
        ]


view : Model -> List (Html msg)
view model =
    [ viewHeader
    ]
