$ ->
  $autocomplete = $('#attribution')

  render = (term, data, type) -> term
  select = (term, data, type) ->
    $("#image_#{type}").val(term)
    $("#image_#{type}_display").html(term).addClass('flash')
    $autocomplete.val('')
    $('#soulmate').hide()


  $autocomplete.soulmate({
    url:            '/autocomplete/search'
    types:          ['source']
    renderCallback: render
    selectCallback: select
    minQueryLength: 2
    maxResults:    10
  })
