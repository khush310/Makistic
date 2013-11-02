M.provide "Views.Fans", {}

class M.Views.Fans.Gencount extends Backbone.Marionette.ItemView
  type: "itemview"
  id: "gencountView"
  template: """
    <div id="male">{{fan_male_count data}}%</div>
    <div id="female">{{fan_female_count data}}%</div>
  """