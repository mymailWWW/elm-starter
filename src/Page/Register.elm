module Page.Register exposing (Model, Msg, toSession, init, update, view, subscriptions)

import Session exposing (Session)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Email as Email
import Password as Password
import Username as Username
import Route as Route
import Generic.List exposing (takeWhile)


-- ---------------------------
-- INIT
-- ---------------------------

emptyForm : Form
emptyForm =
    { email = ""
    , password = ""
    , repeatPassword = ""
    , name = ""
    }

init : Session -> ( Model, Cmd Msg )
init session =
    ({ session = session
    , form = emptyForm
    , formState = NoneActive
    , problems = [] }
    , Cmd.none )

-- ---------------------------
-- TYPE
-- ---------------------------

type alias Form =
    { email : String, password : String, repeatPassword : String, name : String }

type FormState =
    NoneActive
    | Active Field

type Field =
    Email
    | Password
    | RepeatPassword
    | Name

type TrimmedForm = Trimmed Form

type Problem
    = InvalidEntry Field String
    -- | ServerError (Graphql.Http.Error Me)

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
            , repeatPassword = String.trim form.repeatPassword
            , name = String.trim form.name
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
                Password.validate form.password

            RepeatPassword ->
                if String.isEmpty form.repeatPassword then
                    [ "password can't be blank." ]
                else if form.password /= form.repeatPassword then
                    [ "passwords must be iquals." ]
                else
                    []

            Name ->
                if String.isEmpty form.name then
                    [ "username can't be blank." ]
                else if (String.length form.name ) < Username.minLength then
                    [ "username must be at least " ++ String.fromInt Username.minLength  ++ " long." ]
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
    | EnteredRepeatPassword String
    | EnteredName String
    | SubmittedForm
    | FocusedEmail
    | FocusedPassword
    | FocusedRepeatPassword
    | FocusedName
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

        EnteredRepeatPassword repeatPassword ->
            updateForm (\form -> {form | repeatPassword = repeatPassword}) model

        EnteredName name ->
            updateForm (\form -> {form | name = name}) model

        FocusedName ->
            ({ model | formState = Active Name, problems = [] }, Cmd.none )

        FocusedEmail ->
            focus model Email

        FocusedPassword ->
            focus model Password

        FocusedRepeatPassword ->
            focus model RepeatPassword

        SubmittedForm ->
            case validate model.form fieldsInOrder of
                Ok trimmedForm ->
                    ({ model | problems = [] }
                    -- Here put your register command
                    -- , register trimmedForm SentCredentials
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

-- Order of fields to validate
fieldsInOrder : List Field
fieldsInOrder = [ Name, Email, Password, RepeatPassword ]

-- Internal Helper
updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm updater model =
    ({ model | form = updater model.form }, Cmd.none )

-- Delete the problem of the active field
deleteFieldProblems : List Problem -> Field -> List Problem
deleteFieldProblems problems activeField =
    List.filter
      (\e -> case e of
          InvalidEntry field msg ->
              field /= activeField
          -- _ ->
          --     False
      )
      problems

-- Helper function to set the active field and validate the previous fields
focus : Model -> Field -> ( Model, Cmd Msg )
focus model activeField =
    let beforeActive = takeWhile (\field -> field /= activeField ) fieldsInOrder
        withFormState = { model | formState = Active activeField }
    in
    case validate model.form beforeActive of
        Ok trimmedForm ->
            ({ withFormState | problems = [] }, Cmd.none )
        Err problems ->
            ({ withFormState | problems = problems }, Cmd.none )

-- ---------------------------
-- VIEW
-- ---------------------------

view : Model -> { title : String, content : Html msg }
view model =
    { title = "register",
      content = div [ class "proof" ] []
    }

-- ---------------------------
-- SUBSCRIPTION
-- ---------------------------

subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)
