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
    
  recalc_line: (id) ->
    p = $("#invoice_line_items_attributes_#{id}_price")
    q = $("#invoice_line_items_attributes_#{id}_quantity")
    t1 = $("#invoice_line_items_attributes_#{id}_tax1")
    t2 = $("#invoice_line_items_attributes_#{id}_tax2")
    tt = $("#invoice_line_items_attributes_#{id}_line_total")
    
    tax1 = $(".tax1").data("taxvalue")
    tax1 = 0 if isNaN(tax1)
    
    tax2 = $(".tax2").data("taxvalue");
    tax2 = 0 if isNaN(tax2)
    
    tax2comp = $(".tax2").data("taxcompound") || false
    
    price = parseFloat(p.val());
    price = 0 if isNaN(price)
        
    quantity = parseFloat(q.val())
    quantity = 0 if isNaN(quantity)

    row = p.closest(".fields")

    subtotal = Math.round(price * quantity * 100) / 100

    row.find("div.item-subtotal").html(subtotal)
    taxes = row.find("select.item-select-tax").val()
    taxtotal = 0;

    if tax1 > 0 and (taxes == "1" or taxes == "3")
      t1.val(Math.round(subtotal * tax1) / 100)
      taxtotal += Math.round(subtotal * tax1) / 100
    else
      t1.val("")
      
    if tax2 > 0 and (taxes == "2" or taxes == "3")
      tax2value = if tax2comp then (Math.round((subtotal + taxtotal) * tax2) / 100) else (Math.round(subtotal * tax2) / 100)
      t2.val(tax2value)
      taxtotal += tax2value
    else
      t2.val("")
      
    tt.val(Math.round((subtotal + taxtotal)*100)/100)
    Invoices.Form.recalc_totals()
   
  recalc_totals: ->
    subtotal = 0.0
    taxtotal1 = 0.0
    taxtotal2 = 0.0
    $(".item-subtotal").each ->
      if $(this).closest(".fields").is(":visible")
        subtotal += parseFloat($(this).text()) 
    $(".item-tax1 input").each ->
      if $(this).closest(".fields").is(":visible")
        if parseFloat($(this).val()) > 0 
          taxtotal1 += parseFloat($(this).val())
        
    $(".item-tax2 input").each ->
      if $(this).closest(".fields").is(":visible")
        if parseFloat($(this).val()) > 0 
          taxtotal2 += parseFloat($(this).val())    
        
    $("#subtotal").html(Math.round(subtotal * 100) / 100)
    $("#taxtotal1").html(Math.round(taxtotal1 * 100) / 100)
    $("#taxtotal2").html(Math.round(taxtotal2 * 100) / 100)
    
    
    discount = 0
    if parseFloat($("#invoice_discount").val()) > 0
      discount = parseFloat($("#invoice_discount").val()) / 100
    discount_amount = Math.round(subtotal * discount * 100) / 100
    
    total = subtotal + taxtotal1 + taxtotal2 - discount_amount
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