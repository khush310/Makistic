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
        <div id="fans">
          <div id="male"></div>
          <div id="female"></div>
          <div id="fancount"></div>
        </div>
        <div id="fanlocation">
          Here's where they come from...
        </div>
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

    @showGraph()

  showGraph: () =>
    d3.json "uk.json", (error, uk) ->
      width = 960
      height = 1160
      svg = d3.select("body").append("svg").attr("width", width).attr("height", height)
      subunits = topojson.feature(uk, uk.objects.subunits)
      projection = d3.geo.albers().center([0, 55.4]).rotate([4.4, 0]).parallels([50, 60]).scale(6000).translate([width / 2, height / 2])
      path = d3.geo.path().projection(projection)
      svg.selectAll(".subunit").data(topojson.feature(uk, uk.objects.subunits).features).enter().append("path").attr("class", (d) ->
        "subunit " + d.id
      ).attr "d", path
      svg.append("path").datum(topojson.mesh(uk, uk.objects.subunits, (a, b) ->
        a isnt b and a.id isnt "IRL"
      )).attr("d", path).attr "class", "subunit-boundary"
      svg.append("path").datum(topojson.mesh(uk, uk.objects.subunits, (a, b) ->
        a is b and a.id is "IRL"
      )).attr("d", path).attr "class", "subunit-boundary IRL"
      svg.append("path").datum(topojson.feature(uk, uk.objects.places)).attr("d", path).attr "class", "place"
      svg.selectAll(".place-label").data(topojson.feature(uk, uk.objects.places).features).enter().append("text").attr("class", "place-label").attr("transform", (d) ->
        "translate(" + projection(d.geometry.coordinates) + ")"
      ).attr("dy", ".35em").text((d) ->
        d.properties.name
      ).attr("x", (d) ->
        (if d.geometry.coordinates[0] > -1 then 6 else -6)
      ).style "text-anchor", (d) ->
        (if d.geometry.coordinates[0] > -1 then "start" else "end")

      svg.selectAll(".subunit-label").data(topojson.feature(uk, uk.objects.subunits).features).enter().append("text").attr("class", (d) ->
        "subunit-label " + d.id
      ).attr("transform", (d) ->
        "translate(" + path.centroid(d) + ")"
      ).attr("dy", ".35em").text (d) ->
        d.properties.name


