module UserSearch exposing (..)

import GlobalUserSearch exposing (..)
import Global exposing (..)
import Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Backend exposing (searchUsersRequest, avatarUrl)


userSearchUpdate : UserSearchMsg -> Model -> (Model, Cmd UserSearchMsg)
userSearchUpdate msg model =
  case msg of
    SearchUsers -> (model, Http.send SearchUsersCompleted (searchUsersRequest (currentUser model) model.userSearchModel.query))
    SearchUsersCompleted (Ok users) ->
      let searchModel = model.userSearchModel
      in ({model|userSearchModel = {searchModel|results = users}}, Cmd.none)
    SearchUsersCompleted (Err _) ->
      (model, Cmd.none)
    ChangeQuery q ->
      let searchModel = model.userSearchModel
      in ({model|userSearchModel = {searchModel|query = q}}, Cmd.none)

userSearchView : User -> UserSearchModel -> Html Msg
userSearchView currentUser model =
  div [ ] [ input [onInput (\x -> UserSearch (ChangeQuery x)), placeholder "Query", value model.query] []
          , br [] []
          , button [onClick (UserSearch SearchUsers)] [text "Search"]
          , ul [] (List.map (\user -> li [] [
              div [class "profilePreview", onClick (GoToProfile user)] [
                img [src (avatarUrl currentUser user)] [],
                div [class "name"] [text user.name],
                div [class "description"] [text user.description]
              ]
            ]) model.results)
          ]
