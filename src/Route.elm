module Route exposing (Route(..), fromUrl, parser, pushUrl, replaceUrl, href)

import Browser.Navigation as Nav
import Html.Attributes as Attr
import Html exposing (Attribute)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, map, oneOf, s, string, top)
import Username as Username exposing (Username)

-- ---------------------------
-- TYPE
-- ---------------------------

type Route
    = Root
    | Home
    | Login
    | Logout

-- ---------------------------
-- SERIALIZATION
-- ---------------------------

-- We use url parser to parse a route from the URL
-- Main parser
parser : Parser (Route -> a) a
parser =
    oneOf
        [ map Home top
        , Parser.map Login (s "login")
        , Parser.map Logout (s "logout")
        ]

fromUrl : Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser

-- ---------------------------
-- CHANGE URL
-- ---------------------------

href : Route -> Attribute msg
href targetRoute =
    Attr.href (toString targetRoute)

replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (toString route)

-- We can also push a URL with pushstate
pushUrl : Nav.Key -> Route -> Cmd msg
pushUrl key route =
    Nav.pushUrl key (toString route)

-- ---------------------------
-- INTERNAL
-- ---------------------------

toString : Route -> String
toString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Root ->
                    []

                Login ->
                    [ "login" ]

                Logout ->
                    [ "logout" ]

    in
    "#/" ++ String.join "/" pieces
