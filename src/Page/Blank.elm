module Page.Blank exposing (view)

import Html
import Html.Styled exposing (..)


view : { title : String, content : Html msg }
view =
    { title = "blank",
      content = div [] []
    }
