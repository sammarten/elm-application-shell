module Route exposing (Route(..), href, match, pushUrl, replaceUrl)

import Browser.Navigation as Navigation
import Html
import Html.Attributes
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string, top)


type Route
    = Dashboard
    | Listings
    | Profile


routes : Parser (Route -> a) a
routes =
    Parser.oneOf
        [ Parser.map Dashboard top
        , Parser.map Dashboard (s "dashboard")
        , Parser.map Listings (s "listings")
        , Parser.map Profile (s "profile")
        ]


match : Url -> Maybe Route
match url =
    Parser.parse routes url


pushUrl : Navigation.Key -> Route -> Cmd msg
pushUrl navKey route =
    Navigation.pushUrl navKey (routeToUrl route)


replaceUrl : Navigation.Key -> Route -> Cmd msg
replaceUrl key route =
    Navigation.replaceUrl key (routeToUrl route)


routeToUrl : Route -> String
routeToUrl route =
    let
        urlParts =
            case route of
                Dashboard ->
                    [ "dashboard" ]

                Listings ->
                    [ "listings" ]

                Profile ->
                    [ "profile" ]
    in
    "/" ++ String.join "/" urlParts


href : Route -> Html.Attribute msg
href route =
    Html.Attributes.href (routeToUrl route)
