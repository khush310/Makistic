M.provide "Views.Fans", {}

class M.Views.Fans.Gencount extends Backbone.Marionette.ItemView
  type: "itemview"
  id: "gencountView"
  template: """
    <div id="male">{{fan_male_count data}}%</div>
    <div class="chart">

    </div>
    <div id="female">{{fan_female_count data}}%</div>
  """


  onShow: () =>
    @showFanGraph()

  showFanGraph: () =>
    # let's transform the model to somethinglike this
    # [ { label: "F.13-17": 478 }, .. ]
    male_data = []
    female_data = []
    attrs = @model.toJSON().data[0]

    last_value = attrs.values[0]
    _(last_value.value).each (value, key) =>
      if key[0] is "F"
        female_data.push { label: key.slice(2), value: value }
      else if key[0] is "M"
        male_data.push { label: key.slice(2), value: value }

    data = female_data.concat(male_data)
    all_values = _(data).map (el) => el.value
    upper_bound = _(all_values).max()

    @scale = d3.scale.linear().domain([0, upper_bound]).range(["0%", "100%"])

    @createGraph male_data
    @createGraph female_data

  createGraph: (data) =>
    # [ {label: "15-34", value: 4}, .. ]
    data = _(data).sortBy (el) => parseInt(el.label)
    chart = d3.select(".chart").append("div").attr("class", "age")
    chart.selectAll("div")
    .data(data)
    .enter().append("div")
    .style("width", (d) =>
      @scale(d.value)
      
    ).append("span").text( (d) =>
      d.label
    )