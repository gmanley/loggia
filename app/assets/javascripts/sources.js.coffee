render = (term, data, type) -> term
select = (term, data, type) -> console.log("Selected #{term}")

$ ->
  $('#image_source').soulmate {
    url:            '/autocomplete/search'
    types:          ['source']
    renderCallback: render
    selectCallback: select
    minQueryLength: 2
    maxResults:    10
  }
