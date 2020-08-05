module Username exposing (Username, toString, encoder, decoder, urlParser, minLength)

import Url.Parser
import Url exposing (Url)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)


-- ---------------------------
-- TYPE
-- ---------------------------

type Username = Username String

-- ---------------------------
-- VALIDATION
-- ---------------------------

minLength : Int
minLength = 4

-- ---------------------------
-- REPRESENTATIONS
-- ---------------------------

-- String representation
toString : Username -> String
toString (Username uname) =
    uname

-- We could have other representations like html or json

-- ---------------------------
-- SERIALIZATION
-- ---------------------------

encoder : Username -> Value
encoder (Username uname) =
    Encode.string uname

decoder : Decoder Username
decoder =
    Decode.map Username Decode.string

urlParser : Url.Parser.Parser (Username -> a) a
urlParser =
    Url.Parser.custom "USERNAME" (\str -> Just (Username str))
