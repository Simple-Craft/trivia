module Page.Queue exposing (Model, Msg(..), init, update, view)

import Array exposing (Array)
import Html exposing (input, table, td, text, th, thead, tr)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (stopPropagationOn, targetValue)
import Http
import HttpBuilder
import Json.Decode as Decode exposing (int, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode


type alias Model =
    { page : Int
    , maxpage : Int
    , questions : Array Question
    }


type alias Question =
    { id : Int
    , question : String
    , category : String
    , difficulty : String
    , submitter : String
    , correctAnswer : String
    , wrongAnswers : Array String
    , submissionTime : String
    }


type QuestionProperty
    = QuestionText
    | CorrectAnswer
    | WrongAnswer Int
    | Difficulty


type alias QuestionPage =
    { maxpage : Int
    , questions : Array Question
    }


decodeQuestion : Decode.Decoder Question
decodeQuestion =
    Decode.succeed Question
        |> required "id" int
        |> required "question" string
        |> required "category" string
        |> required "difficulty" string
        |> required "submitter" string
        |> required "correctAnswer" string
        |> required "wrongAnswers" (Decode.array string)
        |> required "submissionTime" string


encodeQuestion : Question -> Encode.Value
encodeQuestion question =
    Encode.object
        [ ( "question", Encode.string question.question )
        , ( "difficulty", Encode.string question.difficulty )
        , ( "correctAnswer", Encode.string question.correctAnswer )
        , ( "wrongAnswers", Encode.array Encode.string question.wrongAnswers )
        ]


decodeQuestionPage : Decode.Decoder QuestionPage
decodeQuestionPage =
    Decode.succeed QuestionPage
        |> required "page_count" int
        |> required "questions" (Decode.array decodeQuestion)


type Msg
    = NoOp
    | LoadedQuestionData (Result Http.Error QuestionPage)
    | UpdateQuestion Int QuestionProperty String
    | UpdateQuestionResult (Result Http.Error ())


init : ( Model, Cmd Msg )
init =
    ( { page = 0
      , maxpage = 0
      , questions = Array.empty
      }
    , getQuestions 0
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadedQuestionData result ->
            case result of
                Err _ ->
                    ( model, Cmd.none )

                Ok page ->
                    ( { model | maxpage = page.maxpage, questions = page.questions }, Cmd.none )

        UpdateQuestion idx property value ->
            let
                question =
                    Array.get idx model.questions
            in
            case question of
                Just q ->
                    let
                        ( updatedQuestion, updatedModel ) =
                            updateQuestion model q idx property value
                    in
                    ( updatedModel, postUpdateQuestion q.id updatedQuestion )

                Nothing ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateQuestion : Model -> Question -> Int -> QuestionProperty -> String -> ( Question, Model )
updateQuestion model question idx property value =
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
    ( updatedQuestion, { model | questions = Array.set idx updatedQuestion model.questions } )


getQuestions : Int -> Cmd Msg
getQuestions page =
    ("/admin/queue/" ++ String.fromInt page)
        |> HttpBuilder.get
        |> HttpBuilder.withTimeout 2500
        |> HttpBuilder.withExpect (Http.expectJson LoadedQuestionData decodeQuestionPage)
        |> HttpBuilder.request


postUpdateQuestion : Int -> Question -> Cmd Msg
postUpdateQuestion id question =
    ("/admin/edit/" ++ String.fromInt id)
        |> HttpBuilder.post
        |> HttpBuilder.withTimeout 1000
        |> HttpBuilder.withJsonBody (encodeQuestion question)
        |> HttpBuilder.withExpect (Http.expectWhatever UpdateQuestionResult)
        |> HttpBuilder.request


view : Model -> Html.Html Msg
view model =
    Html.table [] (viewHeader :: viewRows model)


viewHeader : Html.Html Msg
viewHeader =
    thead []
        [ th [] [ text "ID" ]
        , th [] [ text "Question" ]
        , th [] [ text "Category" ]
        , th [] [ text "Difficulty" ]
        , th [] [ text "Correct Answer" ]
        , th [] [ text "Incorrect Answers" ]
        , th [] [ text "Submitter" ]
        , th [] [ text "Actions" ]
        ]


viewRows : Model -> List (Html.Html Msg)
viewRows { questions } =
    Array.toList (Array.indexedMap viewRow questions)


viewRow : Int -> Question -> Html.Html Msg
viewRow idx question =
    tr []
        [ td [] [ text (String.fromInt question.id) ]
        , td [] [ viewInput idx QuestionText question.question ]
        , td [] [ text question.category ]
        , td [] [ text question.difficulty ]
        , td [] [ viewInput idx CorrectAnswer question.correctAnswer ]
        , td [] (viewWrongAnswers idx question)
        , td [] [ text question.submitter ]
        , td [] []
        ]


viewWrongAnswers : Int -> Question -> List (Html.Html Msg)
viewWrongAnswers idx question =
    Array.indexedMap (viewWrongAnswer idx) question.wrongAnswers
        |> Array.toList
        |> List.concat


viewWrongAnswer : Int -> Int -> String -> List (Html.Html Msg)
viewWrongAnswer idx wrongIndex text =
    [ viewInput idx (WrongAnswer wrongIndex) text
    , Html.br [] []
    ]


viewInput : Int -> QuestionProperty -> String -> Html.Html Msg
viewInput idx property v =
    input [ type_ "text", value v, onChange (UpdateQuestion idx property) ] []


onChange : (String -> msg) -> Html.Attribute msg
onChange tagger =
    stopPropagationOn "change" (Decode.map alwaysStop (Decode.map tagger targetValue))


alwaysStop : a -> ( a, Bool )
alwaysStop x =
    ( x, True )
