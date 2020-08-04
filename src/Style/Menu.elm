module Style.Menu exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)


headerCss : List Style
headerCss =
    [ backgroundColor (hex "fff")
    , boxShadow5 (px 1) (px 1) (px 4) (px 0) (rgba 0 0 0 0.1)
    , position fixed
    , top (px 0)
    , width (pct 100)
    , zIndex (int 3)
    ]

headerUlCss : List Style
headerUlCss =
    [ margin (px 0)
    , padding (px 0)
    , listStyle none
    , overflow hidden
    , backgroundColor (hex "fff")
    ]

headerLiACss : List Style
headerLiACss =
    [ display block
    , padding2 (px 10) (px 20)
    , borderRight3 (px 1) solid (hex "f4f4f4")
    , textDecoration none
    , border3 (px 1) solid (hex "f4f4f4")
    , hover [
        backgroundColor (hex "f4f4f4")
      ]
    ]

headerLogoCss : List Style
headerLogoCss =
    [ display block
    , float left
    , padding2 (px 10) (px 20)
    ]
