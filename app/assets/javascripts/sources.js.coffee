$ ->
  $autocomplete = $('#attribution')

  render = (term, data, type) -> term
  selectSuggestion = (term, data, type) ->
    $("#image_#{type}").val(term)
    $("#image_#{type}_display").html(term).addClass('flash')
    $autocomplete.val('')
    $('#soulmate').hide()
  selectCreate = (term, type) ->
    selectSuggestion(term, {}, type)

  $autocomplete.soulmate({
    url:            '/autocomplete/search'
    types:          ['source', 'photographer']
    renderCallback: render
    selectSuggestionCallback: selectSuggestion
    selectCreateCallback: selectCreate
    minQueryLength: 2
    maxResults:    10
  })
