module Page.Home exposing (Model, Msg, toSession, init, update)

import Session exposing (Session)

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
