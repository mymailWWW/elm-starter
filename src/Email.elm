module Email exposing (validate, Email, toString)

import Regex as Regex exposing (Regex)

-- ---------------------------
-- VALIDATION
-- ---------------------------

validEmail : Regex
validEmail =
    let options = { caseInsensitive = True, multiline = False }
        pattern = "^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        maybeRegex = Regex.fromStringWith options pattern
    in
    Maybe.withDefault Regex.never maybeRegex

isValidEmail : String -> Bool
isValidEmail email =
    Regex.contains validEmail email

validate : String -> List String
validate email =
    if String.isEmpty email then
        [ "email can't be blank." ]

    else if not (isValidEmail email) then
        [ "invalid email" ]

    else
        []

-- ---------------------------
-- TYPE
-- ---------------------------

type Email = Email String

-- ---------------------------
-- REPRESENTATIONS
-- ---------------------------

toString : Email -> String
toString (Email e) = e
