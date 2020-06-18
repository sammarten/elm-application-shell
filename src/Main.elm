module Main exposing (Model, Msg(..), init, main, update, view)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Page.Dashboard as Dashboard
import Page.Listings as Listings
import Page.Profile as Profile
import Route
import Url exposing (Url)



---- MODEL ----


type Page
    = Dashboard Dashboard.Model
    | Listings Listings.Model
    | NotFound
    | Profile Profile.Model


type alias Model =
    { navKey : Navigation.Key
    , page : Page
    }


init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    setNewPage (Route.match url) (initialModel navKey)


initialModel : Navigation.Key -> Model
initialModel navKey =
    { navKey = navKey
    , page = NotFound
    }



---- UPDATE ----


type Msg
    = ClickLink UrlRequest
    | DashboardMsg Dashboard.Msg
    | ListingsMsg Listings.Msg
    | NewRoute (Maybe Route.Route)
    | ProfileMsg Profile.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ClickLink urlRequest, _ ) ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Navigation.pushUrl model.navKey (Url.toString url)
                    )

                External url ->
                    ( model
                    , Navigation.load url
                    )

        ( DashboardMsg dashboardMsg, Dashboard dashboardModel ) ->
            let
                ( updatedDashboardModel, dashboardCmd ) =
                    Dashboard.update dashboardMsg dashboardModel
            in
            ( { model | page = Dashboard updatedDashboardModel }
            , Cmd.map DashboardMsg dashboardCmd
            )

        ( ListingsMsg listingsMsg, Listings listingsModel ) ->
            let
                ( updatedListingsModel, listingsCmd ) =
                    Listings.update listingsMsg listingsModel
            in
            ( { model | page = Listings updatedListingsModel }
            , Cmd.map ListingsMsg listingsCmd
            )

        ( NewRoute maybeRoute, _ ) ->
            setNewPage maybeRoute model

        ( ProfileMsg profileMsg, Profile profileModel ) ->
            let
                ( updatedProfileModel, profileCmd ) =
                    Profile.update profileMsg profileModel
            in
            ( { model | page = Profile updatedProfileModel }
            , Cmd.map ProfileMsg profileCmd
            )

        _ ->
            ( model, Cmd.none )


setNewPage : Maybe Route.Route -> Model -> ( Model, Cmd Msg )
setNewPage maybeRoute model =
    case maybeRoute of
        Just Route.Dashboard ->
            let
                ( dashboardModel, dashboardCmd ) =
                    Dashboard.init
            in
            ( { model | page = Dashboard dashboardModel }, Cmd.map DashboardMsg dashboardCmd )

        Just Route.Listings ->
            let
                ( listingsModel, listingsCmd ) =
                    Listings.init
            in
            ( { model | page = Listings listingsModel }, Cmd.map ListingsMsg listingsCmd )

        Just Route.Profile ->
            let
                ( profileModel, profileCmd ) =
                    Profile.init
            in
            ( { model | page = Profile profileModel }, Cmd.map ProfileMsg profileCmd )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )



---- VIEW ----


view : Model -> Document Msg
view model =
    let
        ( title, content ) =
            viewContent model.page
    in
    { title = title
    , body = [ content ]
    }


viewContent : Page -> ( String, Html Msg )
viewContent page =
    case page of
        Dashboard dashboardModel ->
            ( "Dashboard"
            , Dashboard.view dashboardModel |> Html.map DashboardMsg
            )

        Listings listingsModel ->
            ( "Listings"
            , Listings.view listingsModel |> Html.map ListingsMsg
            )

        Profile profileModel ->
            ( "Profile"
            , Profile.view profileModel |> Html.map ProfileMsg
            )

        NotFound ->
            ( "Page Not Found"
            , text "could not find this page"
            )



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = ClickLink
        , onUrlChange = Route.match >> NewRoute
        }
