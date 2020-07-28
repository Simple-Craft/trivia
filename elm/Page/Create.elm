module Page.Create exposing (Model, Msg(..), init, update, view)

import Array exposing (Array)
import Html exposing (div, input, label, select)
import Html.Attributes exposing (class, for, id, type_, value)
import Html.Events exposing (onInput)


type alias Model =
    { question : Question }


type Msg
    = NoOp
    | UpdateQuestion QuestionProperty String
    | SubmitQuestion


type alias Question =
    { question : String
    , category : String
    , difficulty : String
    , correctAnswer : String
    , wrongAnswers : Array String
    }


type QuestionProperty
    = QuestionText
    | CorrectAnswer
    | WrongAnswer Int
    | Difficulty


init : ( Model, Cmd Msg )
init =
    let
        blankQuestion =
            { question = ""
            , category = ""
            , difficulty = "Easy"
            , correctAnswer = ""
            , wrongAnswers = Array.fromList [ "", "", "" ]
            }
    in
    ( { question = blankQuestion }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UpdateQuestion property value ->
            let
                updatedModel =
                    updateQuestion model model.question property value
            in
            ( updatedModel, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateQuestion : Model -> Question -> QuestionProperty -> String -> Model
updateQuestion model question property value =
    let
        updatedQuestion =
            case property of
                QuestionText ->
                    { question | question = value }

                CorrectAnswer ->
                    { question | correctAnswer = value }

                WrongAnswer i ->
                    { question | wrongAnswers = Array.set i value question.wrongAnswers }

                Difficulty ->
                    { question | difficulty = value }
    in
    { model | question = updatedQuestion }


view : Model -> Html.Html Msg
view { question } =
    div []
        [ viewTitle question

        -- , viewInput CorrectAnswer question.correctAnswer
        ]


viewTitle : Question -> Html.Html Msg
viewTitle question =
    div [ class "input-block" ]
        [ label [ for "title" ] [ Html.text "Title" ]
        , viewInput "title" QuestionText question.question
        ]


viewInput : String -> QuestionProperty -> String -> Html.Html Msg
viewInput idd property v =
    input [ id idd, type_ "text", value v, onInput (UpdateQuestion property) ] []
