
jQuery ->
  $('#transaction_category_name').autocomplete
    source: $('#transaction_category_name').data('autocomplete-source')