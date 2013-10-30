Handlebars.registerHelper "fan_count_for_today", (resp) =>
  data = resp[0]
  _(data.values).last().value