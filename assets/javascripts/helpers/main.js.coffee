Handlebars.registerHelper "fan_count_for_today", (resp) =>
  data = resp[0]
  _(data.values).last().value

Handlebars.registerHelper "majority_fan", (resp) =>
  data = resp[0]
  last_value = _(data.values).last() 
  count_male = 0
  count_female = 0

  _(last_value.value).each (value, key, list) =>
    if key[0] is "M"
      count_male = count_male + value
    else if key[0] is "F"
      count_female = count_female + value
  if count_female > count_male
    "female"
  else "male"

Handlebars.registerHelper "fan_male_count", (resp) =>
  data = resp[0]

  last_value = _(data.values).last()
  # { "M.13-17": 34, ...  }  
  count = 0
  total_count = 0
  _(last_value.value).each (value, key, list) =>

    total_count = total_count + value
    if key[0] is "M"

      count = count + value

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