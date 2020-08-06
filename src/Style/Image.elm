module Style.Image exposing (imageCss)

import Css exposing (..)
import Html.Styled exposing (..)

imageCss : List Style
imageCss =
  [ Css.width (pct 80)
  , Css.height auto
  , display block
  , marginLeft auto
  , marginRight auto
  ]
