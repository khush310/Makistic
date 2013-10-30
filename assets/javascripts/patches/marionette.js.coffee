Backbone.Marionette.Renderer.render = (template, data) ->
  if _.isFunction(template)
    temp = template(data)
  else
    temp = template
  compiledTemplate = Handlebars.compile temp
  compiledTemplate data

Backbone.Marionette.Region.prototype.show = (view) ->
  @ensureEl()

  view.render()
  @close()

  @open(view)

  if view.onShow then view.onShow()
  view.trigger("show")

  if @onShow then @onShow(view)
  @trigger "view:show", view

  @currentView = view