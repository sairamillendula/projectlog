@Transactions = {}
@Transactions.Index =
  init: ->
    new ToggleSearch($('#toggle_search_form'), $('#transactions-search'), $('#transactions-advanced-search')).toggle()  
    
    if document.URL.indexOf("form=advanced") >= 0
       $("#toggle_search_form").click()
       
    $('#transaction_category_name').live 'focus', ->
      $(this).autocomplete
        source: $('#transaction_category_name').data('autocomplete-source')

	$('#transaction_note').live 'focus', ->
	  $(this).autocomplete
	    source: $('#transaction_note').data('autocomplete-source')
    

@Transactions.Form =
  init: (form_scope) ->
    $("#{form_scope} #transaction_category_name").live 'focus', ->
      $(this).autocomplete
        source: $("#{form_scope} #transaction_category_name").data('autocomplete-source')
        
    $("#{form_scope} #total").live 'keyup', ->
      total = parseFloat($(this).val())
      total = 0 if isNaN(total)
      
      tax1_rate = $("#{form_scope} #tax1_rate").val()
      tax1_rate = 0 if isNaN(tax1_rate) || $("#{form_scope} #tax1_rate").val() == ''
      
      tax2_rate = $("#{form_scope} #tax2_rate").val()
      tax2_rate = 0 if isNaN(tax2_rate) || $("#{form_scope} #tax2_rate").val() == ''
      
      compound = $("#{form_scope} #compound").val() == "true"
      
      subtotal = total
      tax1 = 0
      tax2 = 0
      
      if tax2_rate > 0 and compound
        subtotal = Math.round((total / ((1 + (tax1_rate/100)) * (1 + (tax2_rate/100))))*100)/100
      else
        subtotal = Math.round(total / (1 + (tax1_rate/100) + (tax2_rate/100)) * 100)/100
      
      if tax1_rate > 0
        tax1 = Math.round(subtotal * (tax1_rate/100) * 100)/100
        
      if tax2_rate > 0
        if compound
          tax2 = Math.round((subtotal + tax1) * (tax2_rate/100) * 100)/100
        else
          tax2 = Math.round(subtotal * (tax2_rate/100) * 100)/100
      $("#{form_scope} #tax1").val(tax1)
      $("#{form_scope} #tax2").val(tax2)

@Transactions.MonthlyReport =
  init: ->
    $('#fiscal_year').bind 'change', ->
      window.location = "#{$(this).data('url')}?#{$(this).serialize()}"