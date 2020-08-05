module Generic.List exposing (takeWhile, last)

last : List a -> Maybe a
last list =
    List.head (List.reverse list)

-- TODO tail recursive version

takeWhile : (a -> Bool) -> List a -> List a
takeWhile pred list =
    case list of
        x :: xs ->
            if pred x then
                x :: (takeWhile pred xs)
            else
                []

        [] ->
            []
