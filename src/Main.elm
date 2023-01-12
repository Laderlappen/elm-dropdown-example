module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Json.Decode as Decode exposing (Decoder, Error(..), decodeString, list, string)
import Http


---- MODEL ----


type alias Model =
    { name : String
    , player : String
    , word : String
    , wordList : List String
    }


init : ( Model, Cmd Msg )
init =
    ( {name = ""
    , player = ""
    , word = "Dawn"
    , wordList = ["None"]
    }, fetchWordList )

type alias WordType =
    { words : List String }
    

wordListDecoder : Decode.Decoder WordType
wordListDecoder =
    Decode.map WordType 
        (Decode.field "words" <| Decode.list Decode.string)

fetchWordList : Cmd Msg
fetchWordList =
    Http.get
        { url = "http://shelled-psychedelic-honeycrisp.glitch.me/words"
        , expect = Http.expectJson GotWordList wordListDecoder
        }
        

---- UPDATE ----


type Msg
    = EditName String
    | EditPlayer String
    | Editword String
    | GotWordList (Result Http.Error WordType)
    | NewWords


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        EditName name ->
            ({ model | name = name }, Cmd.none)

        EditPlayer player ->
            ( {model | player = player}, Cmd.none)

        Editword word ->
            ( {model | word = word}, Cmd.none)

        GotWordList (Ok wordList) ->
            ( { model | wordList = List.append ["None"] wordList.words }, Cmd.none)

        GotWordList (Err _) ->
            ( model, Cmd.none)

        NewWords ->
            ( { model | wordList = ["None"] }, fetchWordList )


---- VIEW ----


view : Model -> Html Msg
view model =
    div [] [
        div []
            [ input [ placeholder "Name", onInput EditName] []
            , input [ placeholder "Player", onInput EditPlayer] []
            , wordSelect model.wordList
            ]
        , button [ onClick NewWords ] [text "Get New Words"]
    ]

-- wordSelect : List -> Html Msg
wordSelect words =
    select
        [ onInput Editword]
        ( List.map simpleOption words )

simpleOption : String -> Html msg
simpleOption val =
    option [ value val ] [ text val ]

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
