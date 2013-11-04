M.provide "Views.Home", {}

class M.Views.Home.Main extends Backbone.Marionette.Layout
  type: "layout"
  id: "stage-wrapper"
  template: """
   <div id="header">
      <ul>
        <li class="left-side">
          <span id="logo">
            <a href="#">makistic</a>
          </span>
        </li>
        <li class="center">
          <span id="page">Select your page</span>
          <ul class="arrow_box">
            {{#each data}}
              <li data-id={{id}}>{{name}}</li>
            {{/each}}
          </ul>
        </li>
        <li class="right-side">
          <span id="profileicon">
            <img src="/assets/profilepic.jpg">
          </span>
        </li>
      </ul>
    </div>
    <div class="main">
      <div id="block">
        <div id="title"></div>
        <div class="filler">Here are a few basic stats about this page </div>
        <div id="fans">
          <div id="fancount"></div>
          <div id="gencount"></div>
        </div>
        <div class="filler">here's where they come from</div>
        <div id="fanlocation"></div>
      </div>
    </div>
  """
  regions:  
    titleRegion: '#title'
    fancountRegion: '#fancount'
    fangencountRegion: '#gencount'
    mapRegion: '#fanlocation'
  events:
    "click .arrow_box li": "showPage"


  showPage: (e) =>
    console.log e
    $li = $(e.currentTarget)
    page_id = $li.attr("data-id")
    @current_page_id = page_id
    FB.api "/#{page_id}", (resp) =>
      model = new Backbone.Model resp
      titleView = new M.Views.Title.Main {model: model}
      @titleRegion.show titleView

    FB.api "/#{page_id}/insights/page_fans", (resp) =>
      model = new Backbone.Model resp
      console.log resp
      fancountView = new M.Views.Fans.Count {model: model}
      @fancountRegion.show fancountView

    FB.api "/#{page_id}/insights/page_fans_gender_age", (resp) =>
      model = new Backbone.Model resp
      console.log resp
      fangencountView = new M.Views.Fans.Gencount {model: model}
      @fangencountRegion.show fangencountView
    
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
    console.log "upper bound is #{upper_bound} and lower_bound is #{lower_bound} "

    scale = d3.scale.pow().exponent(1/7).domain([lower_bound, upper_bound]).interpolate(d3.interpolateRgb).range(["#FFFFFF", "#6CB312"]).clamp(true)

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
    svg = d3.select("#fanlocation").append("svg")
    .attr("width", width)
    .attr("height", height)

    d3.json "world-countries.json", (error, world) =>
      console.log world
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
          console.log value
          if value is undefined
            "white" 
          else
            console.log scale(value)
            scale(value)
            # ready = () =>
        else
          "white"
      ).on(
        "click", 
        (d) => 
          three_digit = d.id
          country = _(dictionary).findWhere({ cca3: three_digit })
          if country
            value = data[country.cca2]
            @showCountryData({ value: value, country: country })
      )

  showCountryData: (data) =>
    console.log data
    model = new Backbone.Model data
    #view = new 
    #@graphDeatilsRegion.show