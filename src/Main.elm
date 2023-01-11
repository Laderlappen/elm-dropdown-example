module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode as Decode exposing (Decoder)
import Http


---- MODEL ----


type alias Model =
    { name : String
    , player : String
    , caste : String
    , words : List String
    }


init : ( Model, Cmd Msg )
init =
    ( {name = ""
    , player = ""
    , caste = "Dawn"
    , words = [""]
    }, Cmd.none )



---- UPDATE ----


type Msg
    = EditName String
    | EditPlayer String
    | EditCaste String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        EditName name ->
            ({ model | name = name }, Cmd.none)

        EditPlayer player ->
            ( {model | player = player}, Cmd.none)

        EditCaste caste ->
            ( {model | caste = caste}, Cmd.none)


---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Name", onInput EditName] []
        , input [ placeholder "Player", onInput EditPlayer] []
        , casteSelect
        ]
    

casteSelect : Html Msg
casteSelect =
    select
        [ onInput EditCaste]
        ( List.map simpleOption castes )

simpleOption : String -> Html msg
simpleOption val =
    option [ value val ] [ text val ]

castes : List String
castes = ["Dawn", "Zenith", "Twilight", "Night", "Eclipse"]

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
