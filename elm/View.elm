module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, href, id, src)
import Model exposing (Model, Page(..))
import Msg exposing (Msg(..))
import Page.Create as Create
import Page.List as List
import Page.Queue as Queue


viewButtons : Model -> List (Html msg)
viewButtons model =
    case model.user of
        Just user ->
            let
                queueButton =
                    case user.admin of
                        True ->
                            a [ class "button clickable", href "/admin" ] [ text "Queue" ]

                        False ->
                            Html.text ""
            in
            [ queueButton
            , a [ class "button clickable", href "/create" ] [ text "Create" ]
            , p [ class "button" ] [ text user.username ]
            ]

        Nothing ->
            [ a [ class "button clickable", href "/user/login" ] [ text "Login" ]
            ]


viewHeader : Model -> Html msg
viewHeader model =
    div [ class "header" ]
        [ h1 [] [ text "Trivia DB" ]
        , div [ class "header-right" ] (viewButtons model)
        ]


viewBody : Model -> List (Html msg)
viewBody model =
    case model.page of
        Index ->
            [ viewIndex ]

        Queue m ->
            Queue.view m

        Create m ->
            Create.view m

        List m ->
            List.view m


viewIndex : Html msg
viewIndex =
    div [ class "centered" ]
        [ img [ src "img/logo.png" ] []
        , p [] [ text "User-contributed Trivia Database for the modern world." ]
        ]


view : Model -> List (Html msg)
view model =
    [ viewHeader model
    , div [ class "content" ] (viewBody model)
    ]
