class @ToggleSearch
  constructor: (@toggler, @normal_search, @advanced_search) ->
  toggle: ->  
    @toggler.live 'click', (e) =>
      e.preventDefault()
      @normal_search.toggle("fast")
      @advanced_search.toggle("fast")
    