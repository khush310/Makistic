#= require ./lib/jquery
#= require ./lib/underscore
#= require ./lib/backbone
#= require ./lib/backbone.marionette
#= require ./prelude
#= require ./lib/handlebars
#= require ./lib/d3.v3.min
#= require ./lib/d3.geo.projection.v0.min
#= require ./lib/queue.v1.min
#= require ./lib/topojson.v1.min
#= require_tree ./helpers
#= require_tree ./routes
#= require_tree ./patches
#= require_tree ./views

M.app = new Backbone.Marionette.Application()

M.app.addRegions
  stageRegion: "#stage"


M.app.bind "initialize:after", () =>
  new M.AppRouter()
  window.location.hash = ""
  Backbone.history.start()
  FB.getLoginStatus (
    (resp) ->
      if resp.status is "connected"
        window.location.hash = "home"
      else
        window.location.hash = "landing"
  )

$(document).ready () ->
  M.app.start()