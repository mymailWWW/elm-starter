module Menu exposing (init, Model, Msg, update, view)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick)
import Api exposing (Me)
import Route as Route exposing (Route)

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

-- ---------------------------
-- VIEW
-- ---------------------------

view : Model -> Maybe Me -> Html Msg
view model maybeMe =
    div [ class "header" ] [
      a [ href "#", class "logo" ] [ text "CSS Nav" ]
      , input [ class "menu-btn", type_ "checkbox", id "menu-btn" ] []
      , label [ class "menu-icon", for "menu-btn" ] [
        span [ class "navicon" ] []
      ]
      , ul [ class "menu" ] [
        li [] [ a [ href "#" ] [ text "Our Work" ]]
        , navbarLink Route.Home [ text "Home" ]
        , navbarLink Route.Login [ text "Login" ]
        , li [] [ a [ href "#" ] [ text "Contact" ]]
      ]
    ]

navbarLink : Route -> List ( Html Msg ) -> Html Msg
navbarLink route linkContent =
    li [ class "fade" ] [ a [ Route.href route, onClick LinkClicked ] linkContent ]
