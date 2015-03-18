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
        <li class="right-side"></li>
      </ul>
    </div>
    <div class="main">
      <div id="block">
        <div id="title"></div>
        <div class="filler"><p>Here are a few basic stats about this page</p></div>
        <div id="fans">
          <div id="fancount"></div>
          <div id="gencount"></div>
        </div>
        <div class="filler"><p>Here's where they come from</p></div>
        <div id="fanlocation"></div>
      </div>
    </div>
  """
  regions:  
    titleRegion: '#title'
    profileRegion: '.right-side'
    fancountRegion: '#fancount'
    fangencountRegion: '#gencount'
    mapRegion: '#fanlocation'
  events:
    "click .arrow_box li": "showPage"

  showPage: (e) =>

    $li = $(e.currentTarget)
    page_id = $li.attr("data-id")
    @current_page_id = page_id

    FB.api "/#{page_id}", (resp) =>
      model = new Backbone.Model resp
      titleView = new M.Views.Title.Main {model: model}
      @titleRegion.show titleView

    FB.api "/#{page_id}/insights/page_fans", (resp) =>
      model = new Backbone.Model resp
      fancountView = new M.Views.Fans.Count {model: model}
      @fancountRegion.show fancountView

    FB.api "/#{page_id}/insights/page_fans_gender_age", (resp) =>
      model = new Backbone.Model resp
      fangencountView = new M.Views.Fans.Gencount {model: model}
      @fangencountRegion.show fangencountView
    
    mapView = new M.Views.Map.Main
    mapView.current_page_id = @current_page_id
    @mapRegion.show mapView

  onShow: => 
    FB.api "/me", (resp) =>
      model = new Backbone.Model resp
      profileView = new M.Views.Home.Profile {model: model}
      @profileRegion.show profileView
    