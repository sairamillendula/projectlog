@Invoices = {}
@Invoices.Form =
  init: ->
    $("#invoice_issued_date").datepicker({ dateFormat: 'yy-mm-dd' })
    $("#invoice_due_date").datepicker({ dateFormat: 'yy-mm-dd' })

    $("select.item-select-tax").live "change", ->
      Invoices.Form.recalc_line($(this).closest(".fields").find("input.item-price")[0].id.match(/attributes_([new_\d]+)_/)[1])

    $("input.item-quantity, input.item-price").live "change", ->
      Invoices.Form.recalc_line($(this).prop("id").match(/attributes_([new_\d]+)_/)[1])
      
    $("input.item-quantity, input.item-price").live "keyup", ->
      Invoices.Form.recalc_line($(this).prop("id").match(/attributes_([new_\d]+)_/)[1])
    
    $("#invoice-form").bind "nested:fieldRemoved", ->
      Invoices.Form.recalc_totals()
      
    $("#invoice_discount").change ->
      Invoices.Form.recalc_totals()
        
    $("#invoice_discount").keyup ->
      Invoices.Form.recalc_totals()

    $("#invoice_status").change ->
      $("#invoice-content").removeClass("draft").removeClass("sent").removeClass("partial-payment").removeClass("paid").addClass($("#invoice_status").val().toLowerCase().replace(" ", "-"))

    $("#invoices th a, #invoices .pagination a").live "click", ->
      $.getScript(this.href)
      return false;

    $("#invoice_customer_id").change ->
      customer_id = $(this).val()
      if customer_id != ""
        $.getJSON "/customers/#{customer_id}/projects.json", (json) ->
          if json.length > 0
            $("#invoice_project_id").html("<option value=''>Please select</option>")
            $.each json, (index, project) ->
              $("#invoice_project_id").append("<option value='#{project.id}'>#{project.title}</option>")

            $("#project-field").show()
          else
            $("#project-field").hide()
            $("#invoice_project_id").html("<option value=''>Please select</option>")    
      else
        $("#project-field").hide()
        $("#invoice_project_id").html("<option value=''>Please select</option>")
    
  recalc_line: (id) ->
    p = $("#invoice_line_items_attributes_#{id}_price")
    q = $("#invoice_line_items_attributes_#{id}_quantity")
    
    price = parseFloat(p.val());
    price = 0 if isNaN(price)
        
    quantity = parseFloat(q.val())
    quantity = 0 if isNaN(quantity)

    row = p.closest(".fields")

    subtotal = Math.round(price * quantity * 100) / 100

    row.find("div.item-subtotal").html(subtotal)
    
    Invoices.Form.recalc_totals()
   
  recalc_totals: ->
    subtotal = 0.0
    tax1_rate = parseFloat($('#tax1_rate').val())
    tax1_rate = 0.0 if isNaN(tax1_rate)
    
    tax2_rate = parseFloat($('#tax2_rate').val())
    tax2_rate = 0.0 if isNaN(tax2_rate)
    
    compound = $('#compound').val()
    
    tax1 = 0.0
    tax2 = 0.0
    
    $(".item-subtotal").each ->
      if $(this).closest(".fields").is(":visible")
        subtotal += parseFloat($(this).text()) 
    
    tax1 = Math.round(subtotal * (tax1_rate/100) * 100)/100
    
    if tax2_rate > 0
      if compound == "true"
        tax2 = Math.round((subtotal + tax1) * (tax2_rate/100)*100)/100
      else
        tax2 = Math.round(subtotal * (tax2_rate/100) * 100)/100
        
    $("#subtotal").html(Math.round(subtotal * 100) / 100)
    $("#taxtotal1").html(tax1)
    $("#taxtotal2").html(tax2)
    
    discount = 0.0
    if parseFloat($("#invoice_discount").val()) > 0
      discount = parseFloat($("#invoice_discount").val()) / 100
    discount_amount = Math.round(subtotal * discount * 100) / 100
    
    total = subtotal + tax1 + tax2 - discount_amount
    $("#amount_due").html(Math.round(total * 100)/100)
    
@Invoices.Show =
  init: ->
    if $('#invoice_line_items .line_item').length > 1
      $('#invoice_line_items tbody').sortable
        axis: 'y'
        items: ".line_item"
        update: ->
          $.post($("#invoice_line_items").data('update-url'), $(this).sortable('serialize'))
    else
      $('#invoice_line_items .line_item').addClass('no-drag')