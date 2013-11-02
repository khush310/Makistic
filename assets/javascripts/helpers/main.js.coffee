Handlebars.registerHelper "fan_count_for_today", (resp) =>
  data = resp[0]
  _(data.values).last().value

Handlebars.registerHelper "fan_male_count", (resp) =>
  data = resp[0]
  console.log data
  last_value = _(data.values).last()
  # { "M.13-17": 34, ...  }  
  count = 0
  total_count = 0
  _(last_value.value).each (value, key, list) =>
    console.log key
    total_count = total_count + value
    if key[0] is "M"
      console.log count
      count = count + value
  console.log count
  Math.round((count/total_count)*100)

Handlebars.registerHelper "fan_female_count", (resp) =>
  data = resp[0]
  last_value = _(data.values).last()
  # { "F.13-17": 34, ...  }  
  count = 0
  total_count = 0
  _(last_value.value).each (value, key, list) =>
    total_count = total_count + value
    if key[0] is "F"
      count = count + value
  Math.round((count/total_count)*100)