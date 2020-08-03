module Menu exposing (init, Model, Msg, update)

-- Menu with state

-- ---------------------------
-- INIT
-- ---------------------------

init : Model
init = { open = False }

-- ---------------------------
-- MODEL
-- ---------------------------

type Page
    = Other
    | Home
    | Login

type Msg =
    LinkClicked
    | HamburgerClicked

type alias Model = { open : Bool }

-- ---------------------------
-- UPDATE
-- ---------------------------

update : Msg -> Model -> Model
update msg model =
    model 
