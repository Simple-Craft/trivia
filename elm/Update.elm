module Update exposing (getUserData, router, update)

import Browser
import Browser.Navigation as Nav
import Http
import HttpBuilder
import Model exposing (Model, Page(..), decodeUser)
import Msg exposing (Msg(..))
import Page.Create as Create
import Page.List as List
import Page.Queue as Queue
import Url
import Url.Parser as Parser


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
            router url model

        LoadedUserData result ->
            case result of
                Err _ ->
                    ( model, Cmd.none )

                Ok user ->
                    ( { model | user = Just user }, Cmd.none )

        QueueMsg m ->
            case model.page of
                Queue queue ->
                    passQueue model (Queue.update m queue)

                _ ->
                    ( model, Cmd.none )

        CreateMsg m ->
            case model.page of
                Create create ->
                    passCreate model (Create.update m create)

                _ ->
                    ( model, Cmd.none )

        ListMsg m ->
            case model.page of
                List list ->
                    passList model (List.update m list)

                _ ->
                    ( model, Cmd.none )



-- Page handlers


passQueue : Model -> ( Queue.Model, Cmd Queue.Msg ) -> ( Model, Cmd Msg )
passQueue model ( queue, cmd ) =
    ( { model | page = Queue queue }, Cmd.map QueueMsg cmd )


passCreate : Model -> ( Create.Model, Cmd Create.Msg ) -> ( Model, Cmd Msg )
passCreate model ( create, cmd ) =
    ( { model | page = Create create }, Cmd.map CreateMsg cmd )


passList : Model -> ( List.Model, Cmd List.Msg ) -> ( Model, Cmd Msg )
passList model ( list, cmd ) =
    ( { model | page = List list }, Cmd.map ListMsg cmd )



-- User data API


getUserData : Cmd Msg
getUserData =
    "/user/me/"
        |> HttpBuilder.get
        |> HttpBuilder.withTimeout 1000
        |> HttpBuilder.withExpect (Http.expectJson LoadedUserData decodeUser)
        |> HttpBuilder.request



-- Routing


router : Url.Url -> Model -> ( Model, Cmd Msg )
router url model =
    let
        parser =
            Parser.oneOf
                [ route Parser.top ( model, Cmd.none )
                , route (Parser.s "admin") (passQueue model Queue.init)
                , route (Parser.s "create") (passCreate model Create.init)
                , route (Parser.s "questions") (passList model List.init)
                ]
    in
    case Parser.parse parser url of
        Just parsed ->
            parsed

        Nothing ->
            ( model, Cmd.none )


route : Parser.Parser a b -> a -> Parser.Parser (b -> c) c
route parser handler =
    Parser.map handler parser
