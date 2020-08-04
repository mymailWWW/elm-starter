module Footer exposing (view)

import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)


view : Html msg
view =
    div [ class "footer__wrapper" ] [
      div [ class "footer__container" ] [
        ul [ class "footer__menu__0" ] [
          li [] [ a [ href "#", class "footer__menu__item" ] [ text "actualité" ]]
          , li [] [ a [ href "#", class "footer__menu__item" ] [ text "france" ]]
          , li [] [ a [ href "#", class "footer__menu__item" ] [ text "international" ]]
          , li [] [ a [ href "#", class "footer__menu__item" ] [ text "économie" ]]
        ]
        , ul [ class "footer__menu__1" ] [
          li [] [ a [ href "#", class "footer__menu__item" ] [ text "opinions" ]]
          , li [] [ a [ href "#", class "footer__menu__item" ] [ text "interdit d'interdire" ]]
          , li [] [ a [ href "#", class "footer__menu__item" ] [ text "magazines" ]]
        ]
        , ul [ class "footer__menu__2" ] [
          li [] [ a [ href "#", class "footer__menu__item" ] [ text "documentaires" ]]
          , li [] [ a [ href "#", class "footer__menu__item" ] [ text "vidéos" ]]
          , li [] [ a [ href "#", class "footer__menu__item" ] [ text "rt360" ]]
          , li [] [ a [ href "#", class "footer__menu__item" ] [ text "podcasts" ]]
        ]
        , ul [ class "footer__social" ] [
          a [ class "footer__social__facebook", href "https://facebook.com/" ] []
          , a [ class "footer__social__vk", href "https://vk.com" ] []
          , a [ class "footer__social__twitter", href "https://twitter.com" ] []
          , a [ class "footer__social__rss", href "#" ] []
        ]
      ]
    ]
