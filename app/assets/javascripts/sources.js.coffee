$ ->
  $autocomplete = $('#attribution')

  render = (term, data, type) -> term
  selectSuggestion = (term, data, type) ->
    if data.record_id
      $("#image_sources_#{type}_id").val(data.record_id)
    else
      $("#image_sources_#{type}_name").val(term)
    $("#image_#{type}_display").html(term).addClass('flash')
    $autocomplete.val('')
    $('#soulmate').hide()
  selectCreate = (term, type) ->
    selectSuggestion(term, {}, type)

  $autocomplete.soulmate({
    url:            '/autocomplete/search'
    types:          ['website', 'photographer']
    renderCallback: render
    selectSuggestionCallback: selectSuggestion
    selectCreateCallback: selectCreate
    minQueryLength: 2
    maxResults:    10
  })
