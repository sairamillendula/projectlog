@Subscriptions = {}
@Subscriptions.Form =
  init: ->
    $('.card').click ->
      $('#select-plan .card').removeClass('active')
      if $(this).hasClass('active')
        $(this).removeClass('active')
        $('#subscription_plan_id').val("")
      else
        $(this).addClass('active')
        $('#subscription_plan_id').val($(this).data('plan-id'))
  