module Main exposing (main)

import Html exposing (..)
import Api exposing (Me, application)
import Browser exposing (Document)
import Url exposing (Url)
import Browser.Navigation as Nav
import Json.Encode exposing (Value)
import Page.Home as Home
import Page.Login as Login
import Session exposing (Session, fromMe)
import Route as Route exposing (Route)
import Menu as Menu
import Tuple

-- ---------------------------
-- INIT
-- ---------------------------

init : Maybe Me -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeMe url navKey =
    let ( page, cmd ) =
            changeRouteTo (Route.fromUrl url) (Redirect (fromMe navKey maybeMe))
    in
    ({ menu = Menu.init, page = page }, cmd )


changeRouteTo : Maybe Route -> Page -> ( Page, Cmd Msg )
changeRouteTo maybeRoute page =
    let
        session =
            toSession page
    in
    case maybeRoute of
        Nothing ->
            ( Redirect session, Cmd.none )

        Just Route.Root ->
            ( page, Route.replaceUrl (Session.navKey session) Route.Home )

        Just Route.Home ->
            ( Home.init session )
              |> updateWith Home HomeMsg

        Just Route.Login ->
            ( Login.init session )
              |> updateWith Login LoginMsg

        Just Route.Logout ->
            ( Redirect session, Api.logout )


-- ---------------------------
-- MODEL
-- ---------------------------

-- There is two shared states accross the spa :
-- Menu which holds an open state and
-- Session which is passed to the next page via toSession


type Page =
    Redirect Session
    | NotFound Session
    | Home Home.Model
    | Login Login.Model

type alias Model =
    { page : Page, menu : Menu.Model }

toSession : Page -> Session
toSession page =
    case page of
        Redirect session ->
            session

        NotFound session ->
            session

        Home home ->
            Home.toSession home

        Login login ->
            Login.toSession login

-- ---------------------------
-- MSG
-- ---------------------------

type Msg =
    ClickedLink Browser.UrlRequest
    | ChangeUrl Url
    | LoginMsg Login.Msg
    | HomeMsg Home.Msg
    | MenuMsg Menu.Msg
    | GotSession Session

-- ---------------------------
-- UPDATE
-- ---------------------------

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ChangeUrl url,  _ ) ->
            changeRouteTo (Route.fromUrl url) model.page
            |> Tuple.mapFirst (addPageToModel model)

        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            ( model, Cmd.none )

                        Just _ ->
                            ( model
                            , Nav.pushUrl (Session.navKey (toSession model.page)) (Url.toString url)
                            )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ( HomeMsg subMsg, Home home ) ->
            ( Home.update subMsg home )
                |> updateWith Home HomeMsg
                |> Tuple.mapFirst (addPageToModel model)

        ( LoginMsg subMsg, Login login ) ->
            ( Login.update subMsg login )
                |> updateWith Login LoginMsg
                |> Tuple.mapFirst (addPageToModel model)

        ( MenuMsg subMsg, _ ) ->
            ( Menu.update subMsg model.menu, Cmd.none )
                |> Tuple.mapFirst (addMenuToModel model)

        ( _, _ ) ->
            ( model, Cmd.none )


updateWith :
  ( subPage -> Page )
  -> ( subMsg -> Msg )
  -> ( subPage, Cmd subMsg )
  -> ( Page, Cmd Msg )
updateWith toPage toMsg ( subPage, subCmd ) =
    ( toPage subPage, Cmd.map toMsg subCmd )

addPageToModel : Model -> Page -> Model
addPageToModel model page =
    { model | page = page }

addMenuToModel : Model -> Menu.Model -> Model
addMenuToModel model menu =
    { model | menu = menu }

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
    case model.page of
        Redirect _ ->
            Session.changes GotSession (Session.navKey (toSession model.page))

        _ ->
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
