M.provide "Views.Title", {}

class M.Views.Title.Main extends Backbone.Marionette.ItemView
  type: "itemview"
  id: "title"
  template: """
    <div id="social">{{name}}}</div>
    <div id="pagename">Social Life of</div>
  """
  