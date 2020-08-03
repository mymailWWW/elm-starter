module Session exposing (Session, navKey, changes, fromMe, toMe)

import Browser.Navigation as Nav
import Api exposing (Me, meChanges)

-- ---------------------------
-- TYPE
-- ---------------------------

type Session =
  Guest Nav.Key
  | LoggedIn Nav.Key Me

-- ---------------------------
-- GETTER
-- ---------------------------

navKey : Session -> Nav.Key
navKey session =
    case session of
        Guest key -> key
        LoggedIn key _ -> key

fromMe : Nav.Key -> Maybe Me -> Session
fromMe key maybeMe =
    case maybeMe of
        Just viewerVal ->
            LoggedIn key viewerVal

        Nothing ->
            Guest key

toMe : Session -> Maybe Me
toMe session =
    case session of
        LoggedIn _ me ->
            Just me

        Guest _ ->
            Nothing


changes : (Session -> msg) -> Nav.Key -> Sub msg
changes toMsg key =
    Api.meChanges (\maybeMe -> toMsg (fromMe key maybeMe))
