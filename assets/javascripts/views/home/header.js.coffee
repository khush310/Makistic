M.provide "Views.Home", {}

class M.Views.Home.Profile extends Backbone.Marionette.ItemView
  type: "ItemView"
  id: "profilepic"
  template: """
    <span id="profileicon" style="background-image: url(http://graph.facebook.com/{{id}}/picture)">
      <a href="#"> {{ name }}  </a> 
    </span>
  """
