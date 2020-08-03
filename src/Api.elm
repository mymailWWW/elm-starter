port module Api exposing (..)

import Url exposing (Url)
import Browser.Navigation as Nav
import Browser exposing (Document)
import Username exposing (Username)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Browser

-- ---------------------------
-- TOKEN OBJECT
-- ---------------------------

type Token =
    Token String

-- ---------------------------
-- ME OBJECT
-- ---------------------------

type Me =
    Me Username Token

-- ---------------------------
-- SERIALIZATION
-- ---------------------------

tokenEncoder : Token -> Value
tokenEncoder (Token t) =
    Encode.string t

tokenDecoder : Decoder Token
tokenDecoder =
    Decode.map Token Decode.string

storeMe : Me -> Cmd msg
storeMe (Me uname token) =
    let
        json =
            Encode.object
                [ ( "user"
                  , Encode.object
                        [ ( "username", Username.encoder uname )
                        , ( "token", tokenEncoder token )
                        ]
                  )
                ]
    in
    storeCache (Just json)

storageDecoder : Decoder Me
storageDecoder =
    Decode.field "user"
      (Decode.map2 Me
        (Decode.field "username" Username.decoder)
        (Decode.field "token" tokenDecoder)
      )

-- ---------------------------
-- PORT
-- ---------------------------

port storeCache : Maybe Value -> Cmd msg

-- ---------------------------
-- APPLICATION
-- ---------------------------

application :
    { init : Maybe Me -> Url -> Nav.Key -> ( model, Cmd msg )
      , update : msg -> model -> ( model, Cmd msg )
      , view : model -> Document msg
      , subscriptions : model -> Sub msg
      , onUrlRequest : Browser.UrlRequest -> msg
      , onUrlChange : Url -> msg
    }
    -> Program Value model msg
application config =
    let
        init flags url navKey =
            let maybeMe =
                    Decode.decodeValue Decode.string flags
                        |> Result.andThen (Decode.decodeString storageDecoder)
                        |> Result.toMaybe
            in
            config.init maybeMe url navKey

    in
    Browser.application
        { init = init
        , update = config.update
        , view = config.view
        , subscriptions = config.subscriptions
        , onUrlRequest = config.onUrlRequest
        , onUrlChange = config.onUrlChange
        }
