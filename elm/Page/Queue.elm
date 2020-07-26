module Page.Queue exposing (Model, Msg(..), init, update, view)

import Html exposing (table, td, text, th, thead, tr)
import Http
import HttpBuilder
import Json.Decode as Decode exposing (int, string)
import Json.Decode.Pipeline exposing (required)


type alias Model =
    { page : Int
    , maxpage : Int
    , questions : List Question
    }


type alias Question =
    { id : Int
    , question : String
    , category : String
    , difficulty : String
    , submitter : String
    , correctAnswer : String
    , wrongAnswers : List String
    , submissionTime : String
    }


type alias QuestionPage =
    { maxpage : Int
    , questions : List Question
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
        |> required "wrongAnswers" (Decode.list string)
        |> required "submissionTime" string


decodeQuestionPage : Decode.Decoder QuestionPage
decodeQuestionPage =
    Decode.succeed QuestionPage
        |> required "page_count" int
        |> required "questions" (Decode.list decodeQuestion)


type Msg
    = NoOp
    | LoadedQuestionData (Result Http.Error QuestionPage)


init : ( Model, Cmd Msg )
init =
    ( { page = 0
      , maxpage = 0
      , questions = []
      }
    , getQuestions 0
    )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        LoadedQuestionData result ->
            case result of
                Err _ ->
                    ( model, Cmd.none )

                Ok page ->
                    ( { model | maxpage = page.maxpage, questions = page.questions }, Cmd.none )

        _ ->
            ( model, Cmd.none )


getQuestions : Int -> Cmd Msg
getQuestions page =
    ("/admin/queue/" ++ String.fromInt page)
        |> HttpBuilder.get
        |> HttpBuilder.withTimeout 2500
        |> HttpBuilder.withExpect (Http.expectJson LoadedQuestionData decodeQuestionPage)
        |> HttpBuilder.request


view : Model -> List (Html.Html msg)
view model =
    [ Html.text "Question Queue"
    , Html.table [] (viewHeader :: viewRows model)
    ]


viewHeader : Html.Html msg
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


viewRows : Model -> List (Html.Html msg)
viewRows { questions } =
    List.map viewRow questions


viewRow : Question -> Html.Html msg
viewRow question =
    tr []
        [ td [] [ text (String.fromInt question.id) ]
        , td [] [ text question.question ]
        , td [] [ text question.category ]
        , td [] [ text question.difficulty ]
        , td [] [ text question.correctAnswer ]
        , td [] (List.map text question.wrongAnswers)
        , td [] [ text question.submitter ]
        , td [] []
        ]
