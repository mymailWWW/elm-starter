module Page.Login exposing (Model, Msg, toSession, init, update, view, subscriptions)

import Session exposing (Session)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Email as Email
import Route as Route


-- ---------------------------
-- INIT
-- ---------------------------

init : Session -> ( Model, Cmd Msg )
init session =
    ({ session = session
     , form =
      { email = ""
      , password = ""
      }
    , formState = NoneActive
    , problems = []
    }, Cmd.none )

-- ---------------------------
-- TYPE
-- ---------------------------

type alias Form =
    { email : String, password : String }

type FormState =
    NoneActive
    | Active Field

type Field =
    Email
    | Password

type TrimmedForm = Trimmed Form

type Problem
    = InvalidEntry Field String
    -- | here put server error

-- Example of response when using elm-graphql client
-- type alias ResponseData = RemoteData (Graphql.Http.Error Me) Me

-- ---------------------------
-- MODEL
-- ---------------------------

type alias Model =
    { session : Session
    , form : Form
    , formState : FormState
    , problems : List Problem
    }

-- ---------------------------
-- VALIDATE
-- ---------------------------

trimFields : Form -> TrimmedForm
trimFields form =
    Trimmed { email = String.trim form.email
            , password = String.trim form.password
            }

validate : Form -> List Field -> Result (List Problem) TrimmedForm
validate form fieldsToValidate =
    let
        trimmedForm =
            trimFields form
    in
    case List.concatMap (validateField trimmedForm) fieldsToValidate of
        [] ->
            Ok trimmedForm

        problems ->
            Err problems

validateField : TrimmedForm -> Field -> List Problem
validateField (Trimmed form) field =
    List.map (InvalidEntry field) <|
        case field of
            Email ->
                Email.validate form.email

            Password ->
                if String.isEmpty form.password then
                    [ "password can't be blank." ]

                else
                    []

-- ---------------------------
-- SESSION
-- ---------------------------

toSession : Model -> Session
toSession model = model.session

-- ---------------------------
-- MSG
-- ---------------------------

type Msg =
    EnteredEmail String
    | EnteredPassword String
    | SubmittedForm
    | FocusedEmail
    | FocusedPassword
    -- | SentCredentials ResponseData
    | GotSession Session

-- ---------------------------
-- UPDATE
-- ---------------------------

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EnteredEmail email ->
            updateForm (\form -> {form | email = email}) model

        EnteredPassword password ->
            updateForm (\form -> {form | password = password}) model

        FocusedEmail ->
            ({ model | formState = Active Email }, Cmd.none )

        FocusedPassword ->
            let fieldsToValidate = [ Email ]
                withFormState = { model | formState = Active Password }
            in
            case validate model.form fieldsToValidate of
                Ok trimmedForm ->
                    ({ withFormState | problems = [] }, Cmd.none )
                Err problems ->
                    ({ withFormState | problems = problems }, Cmd.none )

        SubmittedForm ->
            let fieldsToValidate =
                    [ Email
                    , Password
                    ]
            in
            case validate model.form fieldsToValidate of
                Ok trimmedForm ->
                    ( { model | problems = [] }
                    -- Here put your login cmd
                    -- , login trimmedForm SentCredentials
                    , Cmd.none
                    )

                Err problems ->
                    ({ model | problems = problems }, Cmd.none )

        -- SentCredentials (RemoteData.Success user) ->
        --     ( model, storeMe user )
        --
        -- SentCredentials (RemoteData.Failure err) ->
        --     ({ model | problems = (ServerError err) :: model.problems }
        --     , Cmd.none
        --     )
        --
        -- SentCredentials _ ->
        --     ( model, Cmd.none )

        GotSession session ->
            ({ model | session = session }
            , Route.replaceUrl (Session.navKey session) Route.Home)


-- Internal
updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm updater model =
    ({ model | form = updater model.form }, Cmd.none )

-- ---------------------------
-- VIEW
-- ---------------------------

view : Model -> { title : String, content : Html msg }
view model =
    { title = "login",
      content = div [ class "idris" ] []
    }

-- ---------------------------
-- SUBSCRIPTION
-- ---------------------------

subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)
