M.provide "Views.Map", {}

class M.Views.Map.Main extends Backbone.Marionette.Layout
  type: "layout"
  id: "mapView"
  template: """
    <div id="worldmap"> </div>
    <div id="countrydata"> 
      <div class="name"></div>
      <div class="values"></div>
    </div>
  """
  regions:  
    countrydataRegion: '#countrydata'

  onShow: () =>
    $.ajax 
        url: "/countries.json"
        success: (dictionary) =>
          FB.api "/#{@current_page_id}/insights/page_fans_country", (resp) =>
            last_value = resp.data[0].values[0].value
            @showMap(dictionary, last_value)
      
  showMap: (dictionary, data) =>
    width = 550
    height = 600

    ranges = _(data).values()
    upper_bound = _(ranges).max()
    lower_bound = _(ranges).min()

    scale = d3.scale.pow().exponent(1/4).domain([lower_bound, upper_bound]).interpolate(d3.interpolateRgb).range(["#87CEFA", "#0000CD"]).clamp(true)

    # TODO change this projection to something like remittances
    projection = d3.geo.projection(d3.geo.hammer.raw(1.75, 2))
    .rotate([-10, -45])
    .scale(180)
    #projection = d3.geo.winkel3()
    projection.translate([width/2, height/2])
    # check d3 documentation about scales

    # let's create a path
    path = d3.geo.path()
    .projection(projection)

    #let's append a svg in #block
    $("#worldmap").html("")
    svg = d3.select("#worldmap").append("svg")
    .attr("width", width)
    .attr("height", height)

    d3.json "world-countries.json", (error, world) =>
      countries = world.features
      svg.selectAll(".country")
      .data(countries)
      .enter().insert("path", ".graticule")
      .attr("class", "country")
      .attr("d", path)
      .attr("fill", (d) ->
        three_digit = d.id
        country = _(dictionary).findWhere({ cca3: three_digit })
        if country
          value = data[country.cca2]
          if value is undefined
            "antiquewhite" 
          else
            scale(value)
            # ready = () =>
        else
          "antiquewhite"
      ).on(
        "mouseover", 
        (d) => 
          three_digit = d.id
          country = _(dictionary).findWhere({ cca3: three_digit })
          if country
            value = data[country.cca2]
            @showCountryData({ value: value, country: country })
      )

  showCountryData: (data) =>
    $(".name").html(data.country.name)
    console.log data.country
    $(".values").html(data.value)



