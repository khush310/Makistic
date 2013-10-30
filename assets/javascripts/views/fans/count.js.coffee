M.provide "Views.Fans", {}

class M.Views.Fans.Count extends Backbone.Marionette.ItemView
  type: "itemview"
  id: "fancount"
  template: """
  <p> This page has {{fan_count_for_today data}} fans!
  """