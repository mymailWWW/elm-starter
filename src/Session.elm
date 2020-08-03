module Session exposing (Session, navKey, changes, fromMe)

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

changes : (Session -> msg) -> Nav.Key -> Sub msg
changes toMsg key =
    Api.meChanges (\maybeMe -> toMsg (fromMe key maybeMe))
