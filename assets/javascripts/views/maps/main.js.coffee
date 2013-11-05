M.provide "Views.Map", {}

class M.Views.Map.Main extends Backbone.Marionette.Layout
  type: "layout"
  id: "mapView"
  template: """
    <div id="map"> </div>
    <div id="countrydata"> </div>
  """

  