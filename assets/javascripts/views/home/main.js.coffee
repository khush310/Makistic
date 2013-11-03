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
        <div id="topfans">
          Top 5 fans of your page are ...
          <div id="fan1"></div>
          <div id="fan2"></div>
          <div id="fan3"></div>
          <div id="fan4"></div>
          <div id="fan5"></div>
        </div>
      </div>
    </div>
  """
  regions:  
    titleRegion: '#title'
    fancountRegion: '#fancount'
    fangencountRegion: '#gencount'
  events:
    "click .arrow_box li": "showPage"


  showPage: (e) =>
    console.log e
    $li = $(e.currentTarget)
    page_id = $li.attr("data-id")
    
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
    
    @showMap()
    
  showMap: () =>
    width = 550
    height = 600

    # TODO change this projection to something like remittances
    projection = d3.geo.projection(d3.geo.hammer.raw(1.75, 2))
    .rotate([-10, -45])
    .scale(180)
    #projection = d3.geo.winkel3()
    projection.translate([width/2, height/2])
    # check d3 documentation about scales
    color = d3.scale.category20()

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
      .on(
        "click", 
        (d) => 
          @showCountryData(d.id)
      )

  showCountryData: (country_id) =>
    console.log country_id