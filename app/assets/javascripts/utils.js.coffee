$.fn.presence = ->
  @exists() && this

$.fn.exists = ->
  !!@length
