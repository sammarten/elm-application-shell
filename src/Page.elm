module Page exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)



---- MODEL ----


type Layout
    = Fullscreen (Html msg)
    | App (Html msg)
    | AppWithSlideover (Html msg) (Html msg)
    | AppWithModal (Html msg) (Html msg)


type alias Model =
    { layout : Layout
    , maybeAlert : Maybe Html msg
    }
