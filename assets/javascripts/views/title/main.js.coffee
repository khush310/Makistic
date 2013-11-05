M.provide "Views.Title", {}

class M.Views.Title.Main extends Backbone.Marionette.ItemView
  type: "itemview"
  id: "titleView"
  template: """
    <div id="social">{{name}}}</div>
    <div id="pagename">The <p>facebook</p> Social Life of</div>
  """
  