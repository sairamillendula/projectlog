@Transactions = {}
@Transactions.Index =
  init: ->
    new ToggleSearch($('#toggle_search_form'), $('#transactions-search'), $('#transactions-advanced-search')).toggle()
    
    if document.URL.indexOf("form=advanced") >= 0
       $("#toggle_search_form").click();
    
    $('#transaction_category_name').autocomplete
      source: $('#transaction_category_name').data('autocomplete-source')