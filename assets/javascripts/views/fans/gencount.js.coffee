M.provide "Views.Fans", {}

class M.Views.Fans.Gencount extends Backbone.Marionette.ItemView
  type: "itemview"
  id: "gencountView"
  template: """
    <div id="male">{{fan_male_count data}}%</div>
    <div class="chart"></div>
    <div id="female">{{fan_female_count data}}%</div>
  """

  onShow: () =>
    @showFanGraph()

  showFanGraph: () =>
    data = @model.toJSON()
    console.log data
    chart = d3.select("").append("div").attr("class", "chart")
    chart.selectAll("div")
    .data(data)
    .enter().append("div")
    .style("height", () ->
      d3.scale.linear().domain([0, d3.max(data)]).range(["0px", "420px"])
    )