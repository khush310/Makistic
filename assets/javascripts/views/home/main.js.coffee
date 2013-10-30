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

