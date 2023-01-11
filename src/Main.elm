module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode as Json
import Http


---- MODEL ----


type alias Model =
    { name : String
    , player : String
    , caste : String
    , words : List String
    }

type alias WordList = 
    { words : List String}


init : ( Model, Cmd Msg )
init =
    ( {name = ""
    , player = ""
    , caste = "Select"
    , words = [""]
    }
    , fetchWords)



---- UPDATE ----


type Msg
    = EditName String
    | EditPlayer String
    | EditCaste String
    | GotNewWords (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        EditName name ->
            ({ model | name = name }, Cmd.none)

        EditPlayer player ->
            ( {model | player = player}, Cmd.none)

        EditCaste caste ->
            ( {model | caste = caste}, Cmd.none)
        
        GotNewWords (Ok randomWords) ->
            ( {model | words = randomWords.words}, Cmd.none)

        GotNewWords (Err _) ->
            ( model, Cmd.none )
        


fetchWords : Cmd Msg
fetchWords =
    Http.get { url = "impartial-steel-cerise.glitch.me/random-words"
    , expect = Http.expectJson wordListDecoder }
    GotNewWords
    

wordListDecoder : Json.Decoder WordList
wordListDecoder =
    Json.map WordList (Json.field "randomWords" (Json.list Json.string))

---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Name", onInput EditName] []
        , input [ placeholder "Player", onInput EditPlayer] []
        --, div [] (List.map (text >> span []) model.words)
        ]
{-        , casteSelect
        ]
    

casteSelect : Html Msg
casteSelect =
    select
        [ onInput EditCaste]
        ( List.map simpleOption model.words )

simpleOption : String -> Html msg
simpleOption val =
    option [ value val ] [ text val ]

castes : List String
castes = ["Dawn", "Zenith", "Twilight", "Night", "Eclipse"]
 -}
---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
