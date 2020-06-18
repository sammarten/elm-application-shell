module Page.Profile exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)



---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div
        [ class "flex"
        , class "flex-col"
        , class "items-center"
        , class "justify-center"
        , class "text-3xl"
        , class "text-orange-300"
        ]
        [ div
            []
            [ text "Profile Page" ]
        ]
