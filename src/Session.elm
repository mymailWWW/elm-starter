module Session exposing (..)

import Browser.Navigation as Nav
import Api exposing (Me)

-- ---------------------------
-- TYPE
-- ---------------------------

type Session =
  Guest Nav.Key
  | LoggedIn Nav.Key Me
