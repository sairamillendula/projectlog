@Customers = {}
@Customers.Show =
  init: ->
    $('#contacts').on "hover", ".contact", (e) ->
      actions = $(this).find('.actions')
      if e.type == "mouseenter"
        actions.show()
      else
        actions.hide()