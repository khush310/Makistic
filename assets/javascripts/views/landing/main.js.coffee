# right now M exists, but .Views and .Views.Landing don't. So lets provide it as {}. Now because M.Views.Landing = {}; we can define M.Views.Landing.Main as a class. 

M.provide "Views.Landing", {}

class M.Views.Landing.Main extends Backbone.Marionette.ItemView
  type: "ItemView"
  id: "landing"
  
  template: """
    <div id="matisticlogin">
      <p> matistic </p>
      <p id="login"> <a id="button" href="#login" type="submit"> Login with Facebook </a> </p>
    </div>
  """

