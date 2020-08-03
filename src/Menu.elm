module Menu exposing (init, Model, Msg, update, view)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick)
import Api exposing (Me)
import Route as Route exposing (Route)
import Style.Menu exposing (..)
import Css exposing (..)


-- Menu with state

-- ---------------------------
-- INIT
-- ---------------------------

init : Model
init = { checked = False }

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

type alias Model = { checked : Bool }

-- ---------------------------
-- UPDATE
-- ---------------------------

update : Msg -> Model -> Model
update msg model =
    case msg of
        HamburgerClicked ->
            { model | checked = not model.checked }

        LinkClicked ->
            { model | checked = False }

-- ---------------------------
-- VIEW
-- ---------------------------

toClassName : String -> Bool -> String
toClassName baseName checked =
    if checked then
        baseName ++ "__checked"
    else
        baseName

view : Model -> Maybe Me -> Html Msg
view model maybeMe =
    div [ class "header", css headerCss ] [
      a [ href "#", class "logo", css headerLogoCss ] [ text "CSS Nav" ]
      , div [ class (toClassName "menu-btn" model.checked)
            , id "menu-btn"
            , css [ hover [ backgroundColor (hex "f4f4f4") ]]]
            []
      , label [ class "menu-icon", for "menu-btn", onClick HamburgerClicked ] [
        span [ class "navicon" ] []
      ]
      , ul [ class "menu", css headerUlCss ] [
        navbarLink Route.Home [ text "Our Work" ]
        , navbarLink Route.Home [ text "Home" ]
        , navbarLink Route.Login [ text "Login" ]
        , navbarLink Route.Home [ text "Contact" ]
      ]
    ]

navbarLink : Route -> List ( Html Msg ) -> Html Msg
navbarLink route linkContent =
    li [ class "fade" ] [ a [ Route.href route, onClick LinkClicked, css headerLiACss ] linkContent ]
