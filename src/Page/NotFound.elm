module Page.NotFound exposing (view)

import Html
import Html.Styled exposing (..)


view : { title : String, content : Html msg }
view =
    { title = "No found",
      content = div [] []
    }
