module Main exposing (main)

import Html exposing (..)
import Api exposing (Me, application)
import Browser exposing (Document)
import Url exposing (Url)
import Browser.Navigation as Nav
import Json.Encode exposing (Value)

-- ---------------------------
-- INIT
-- ---------------------------

init : Maybe Me -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeMe url navKey =
    Debug.todo "init"

-- ---------------------------
-- MODEL
-- ---------------------------

type alias Model =
    { counter : Int
    }

-- ---------------------------
-- UPDATE
-- ---------------------------

type Msg =
    ClickedLink Browser.UrlRequest
    | ChangeUrl Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )

-- ---------------------------
-- VIEW
-- ---------------------------

view : Model -> Document Msg
view model =
    { title = "Main Page"
    , body = [ div [] [ text "Hello elm" ] ]
    }

-- ---------------------------
-- SUBCRIPTION
-- ---------------------------

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- ---------------------------
-- MAIN
-- ---------------------------

main : Program Value Model Msg
main =
    Api.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangeUrl
        }
