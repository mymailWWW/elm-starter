module Password exposing (validate)

-- TODO password must contains etc

minLength : Int
minLength = 6

validate : String -> List String
validate password =
    if String.isEmpty password then
        [ "password can't be blank." ]

    else if (String.length password) < minLength then
        [ "password must be at least " ++ String.fromInt minLength  ++ " long." ]
    else
        []
