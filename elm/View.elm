module View exposing (view)

import Html exposing (Html, a, div, h1, img, p, text)
import Html.Attributes exposing (class, href, src)
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
                    if user.admin then
                        a [ class "button clickable", href "/admin" ] [ text "Queue" ]

                    else
                        Html.text ""
            in
            [ queueButton
            , a [ class "button clickable", href "/create" ] [ text "Create" ]
            , a [ class "button clickable", href "/list" ] [ text "List" ]
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


viewBody : Model -> Html Msg
viewBody model =
    case model.page of
        Index ->
            viewIndex

        Queue m ->
            Html.map Msg.QueueMsg <| Queue.view m

        Create m ->
            Html.map Msg.CreateMsg <| Create.view m

        _ ->
            viewIndex


viewIndex : Html msg
viewIndex =
    div [ class "centered" ]
        [ img [ src "img/logo.png" ] []
        , p [] [ text "User-contributed Trivia Database for the modern world." ]
        ]


view : Model -> List (Html Msg)
view model =
    [ viewHeader model
    , div [ class "content" ] [ viewBody model ]
    ]
