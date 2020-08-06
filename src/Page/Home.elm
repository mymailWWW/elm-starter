module Page.Home exposing (Model, Msg, toSession, init, update, view)

import Session exposing (Session)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Style.Image exposing (imageCss)

-- ---------------------------
-- INIT
-- ---------------------------

init : Session -> ( Model, Cmd Msg )
init session =
    ({ session = session }, Cmd.none )

-- ---------------------------
-- TYPE
-- ---------------------------

type alias Model =
    { session : Session }

-- ---------------------------
-- SESSION
-- ---------------------------

toSession : Model -> Session
toSession model = model.session

-- ---------------------------
-- MSG
-- ---------------------------

type Msg =
    NoOp

-- ---------------------------
-- UPDATE
-- ---------------------------

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )

-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> { title : String, content : Html msg }
view model =
    { title = "home",
      content = img [ src "images/haskell.png", css imageCss ] []
    }
