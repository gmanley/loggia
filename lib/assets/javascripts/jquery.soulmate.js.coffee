$ = jQuery

class Query
  constructor: (@minLength) ->
    @value = ''
    @lastValue = ''
    @emptyValues = []

  getValue: ->
    @value

  setValue: (newValue) ->
    @lastValue = @value
    @value = newValue

  hasChanged: ->
    !(@value == @lastValue)

  markEmpty: ->
    @emptyValues.push( @value )

  willHaveResults: ->
    @_isValid() && !@_isEmpty()

  _isValid: ->
    @value.length >= @minLength

  # A value is empty if it starts with any of the values
  # in the emptyValues array.
  _isEmpty: ->
    for empty in @emptyValues
      return true if @value[0...empty.length] == empty
    return false

class CreateSuggestion
  constructor: (index, @term, @type) ->
    @id = "#{index}-soulmate-create-#{@type}"
    @index = index

  select: (callback) ->
    callback( @term, @type, @index, @id)

  focus: ->
    @element().addClass( 'focus' )

  blur: ->
    @element().removeClass( 'focus' )

  render: (callback) ->
    # TOOD: Allow customization of callback
    """
      <li id="#{@id}" class="soulmate-suggestion soulmate-create">
        New #{@type} <b>#{@term}</b>
      </li>
    """

  element: ->
    $('#' + @id)

class Suggestion
  constructor: (index, @term, @data, @type) ->
    @id = "#{index}-soulmate-suggestion"
    @index = index

  select: (callback) ->
    callback( @term, @data, @type, @index, @id)

  focus: ->
    @element().addClass( 'focus' )

  blur: ->
    @element().removeClass( 'focus' )

  render: (callback) ->
    """
      <li id="#{@id}" class="soulmate-suggestion">
        #{callback( @term, @data, @type, @index, @id)}
      </li>
    """

  element: ->
    $('#' + @id)

class SuggestionCollection
  constructor: (@renderCallback, @selectSuggestionCallback, @selectCreateCallback) ->
    @focusedIndex = -1
    @suggestions = []
    @existingTerms = {}

  update: (results, term) ->
    @suggestions = []
    i = 0

    for type, typeResults of results
      @existingTerms[type] = []
      for result in typeResults
        @suggestions.push( new Suggestion(i, result.term, result.data, type) )
        @existingTerms[type].push( result.term )
        i += 1
      unless term in @existingTerms[type]
        @suggestions.push( new CreateSuggestion(i, term, type) )
        i += 1

  blurAll: ->
    @focusedIndex = -1
    suggestion.blur() for suggestion in @suggestions

  render: ->
    h = ''

    if @suggestions.length

      type = null

      for suggestion in @suggestions

        if suggestion.type != type

          h += @_renderTypeEnd( type ) unless type == null
          type = suggestion.type
          h += @_renderTypeStart()

        h += @_renderSuggestion( suggestion )

      h += @_renderTypeEnd( type )

    return h

  count: ->
    @suggestions.length

  focus: (i) ->
    if i < @count()
      @blurAll()

      if i < 0
        @focusedIndex = -1

      else
        @suggestions[i].focus()
        @focusedIndex = i

  focusElement: (element) ->
    index = parseInt( $(element).attr('id') )
    @focus( index )

  focusNext: ->
    @focus( @focusedIndex + 1 )

  focusPrevious: ->
    @focus( @focusedIndex - 1 )

  selectFocused: ->
    if @focusedIndex >= 0
      suggestion = @suggestions[@focusedIndex]
      callback =
        if ~suggestion.id.indexOf('soulmate-create')
          @selectCreateCallback
        else
          @selectSuggestionCallback
      suggestion.select( callback )

  allBlured: ->
    @focusedIndex == -1

  hasSuggestionWithTerm: (term) ->


  # PRIVATE

  _renderTypeStart: ->
    """
      <li class="soulmate-type-container">
        <ul class="soulmate-type-suggestions">
    """

  _renderTypeEnd: (type) ->
    """
        </ul>
        <div class="soulmate-type">#{type}</div>
      </li>
    """

  _renderSuggestion: (suggestion) ->
    suggestion.render( @renderCallback )

class Soulmate

  KEYCODES = {9: 'tab', 13: 'enter', 27: 'escape', 38: 'up', 40: 'down'}

  constructor: (@input, options) ->

    that = this

    {url, types, renderCallback, selectSuggestionCallback, selectCreateCallback, maxResults, minQueryLength, timeout} = options


    @url              = url
    @types            = types
    @maxResults       = maxResults
    @timeout          = timeout || 500

    @xhr              = null

    @suggestions      = new SuggestionCollection( renderCallback, selectSuggestionCallback, selectCreateCallback )
    @query            = new Query( minQueryLength )

    if ($('ul#soulmate').length > 0)
      @container = $('ul#soulmate')
    else
      @container = $('<ul id="soulmate">').insertAfter(@input)
    @container.delegate('.soulmate-suggestion',
      mouseover: -> that.suggestions.focusElement( this )
      click: (event) ->
        event.preventDefault()
        that.suggestions.selectFocused()

        # Refocus the input field so it remains active after clicking a suggestion.
        that.input.focus()
    )

    @input.
      keydown( @handleKeydown ).
      keyup( @handleKeyup ).
      mouseover( ->
        that.suggestions.blurAll()
      )

  handleKeydown: (event) =>
    killEvent = true

    switch KEYCODES[event.keyCode]

      when 'escape'
        @hideContainer()

      when 'tab'
        @suggestions.selectFocused()

      when 'enter'
        @suggestions.selectFocused()
        # Submit the form if no input is focused.
        if @suggestions.allBlured()
          killEvent = false

      when 'up'
        @suggestions.focusPrevious()

      when 'down'
        @suggestions.focusNext()

      else
        killEvent = false

    if killEvent
      event.stopImmediatePropagation()
      event.preventDefault()

  handleKeyup: (event) =>
    @query.setValue( @input.val() )

    if @query.hasChanged()

      if @query.willHaveResults()

        @suggestions.blurAll()
        @fetchResults()

      else
        @hideContainer()

  hideContainer: ->
    @suggestions.blurAll()

    @container.hide()

    # Stop capturing any document click events.
    $(document).unbind('click.soulmate')

  showContainer: ->
    @container.show()

    # Hide the container if the user clicks outside of it.
    $(document).bind('click.soulmate', (event) =>
      @hideContainer() unless @container.has( $(event.target) ).length
    )

  fetchResults: ->
    # Cancel any previous requests if there are any.
    @xhr.abort() if @xhr?

    @xhr = $.ajax({
      url: @url
      dataType: 'jsonp'
      timeout: @timeout
      cache: true
      data: {
        term: @query.getValue()
        types: @types
        limit: @maxResults
      }
      success: (data) =>
        @update( data.results, @query.getValue() )
    })

  update: (results, term) ->
    @suggestions.update(results, term)
    @container.html( $(@suggestions.render()) )
    @showContainer()

$.fn.soulmate = (options) ->
  new Soulmate($(this), options)
  return $(this)
