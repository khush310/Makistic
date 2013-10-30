class M.AppRouter extends Backbone.Router
	routes:
		"landing": "landing"
		"login": "login"
		"home": "home"

	landing: () ->
		landingView = new M.Views.Landing.Main
		M.app.stageRegion.show landingView

	login: () ->
		FB.login(
			(response) ->
				window.location.hash = "home"
			{scope: 'read_stream,manage_pages,read_insights'}
		)

	home: () ->
		FB.api(
      "/me/accounts", 
      (resp) =>
        model = new Backbone.Model resp
        homeView = new M.Views.Home.Main({model: model})
        M.app.stageRegion.show homeView
    )
		