function recalc_line(id) {
    var p = $("#invoice_line_items_attributes_" + id + "_price");
    var q = $("#invoice_line_items_attributes_" + id + "_quantity");
    var t1 = $("#invoice_line_items_attributes_" + id + "_tax1");
    var t2 = $("#invoice_line_items_attributes_" + id + "_tax2");
    var tt = $("#invoice_line_items_attributes_" + id + "_line_total");
    var tax1 = $(".tax1").data("taxvalue");
    if (isNaN(tax1)) {
        tax1 = 0
    }
    var tax2 = $(".tax2").data("taxvalue");
    if (isNaN(tax2)) {
        tax2 = 0
    }
    var tax2comp = $(".tax2").data("taxcompound") || false;
    var price = parseFloat(p.val());
    if (isNaN(price)) {
        price = 0
    }
    var quantity = parseFloat(q.val());
    if (isNaN(quantity)) {
        quantity = 0
    }

    var row = p.closest(".fields");

    var subtotal = Math.round(price * quantity * 100) / 100;

    row.find("div.item-subtotal").html(subtotal);
    var taxes = row.find("select.item-select-tax").val();
    var taxtotal = 0;

    if (tax1 > 0 && (taxes == "1" || taxes == "3")) {
        t1.val(Math.round(subtotal * tax1) / 100);
        taxtotal += Math.round(subtotal * tax1) / 100;
    } else {
        t1.val("");
    }
    if (tax2 > 0 && (taxes == "2" || taxes == "3")) {
        var tax2value = tax2comp ? (Math.round((subtotal + taxtotal) * tax2) / 100) : (Math.round(subtotal * tax2) / 100);
        t2.val(tax2value);
        taxtotal += tax2value;
    } else {
        t2.val("");
    }
    tt.val(Math.round((subtotal + taxtotal)*100)/100);
    recalc_totals();
}

function recalc_totals() {
    var total = 0.0;
    $(".item-total input").each(function() {
        total += parseFloat($(this).val());
    });
    $("#subtotal").html(Math.round(total * 100) / 100);
    var discount = 0;
    if (parseFloat($("#invoice_discount").val()) > 0) discount = parseFloat($("#invoice_discount").val()) / 100;
    $("#amount_due").html(Math.round(total * (1 - discount) * 100) / 100);
}

$(function() {
    $("#invoice_issued_date").datepicker({ dateFormat: 'yy-mm-dd' });
    $("#invoice_due_date").datepicker({ dateFormat: 'yy-mm-dd' });

    $("select.item-select-tax").live("change", function() {
        recalc_line($(this).closest(".fields").find("input.item-price")[0].id.match(/attributes_([new_\d]+)_/)[1]);
    })

    $("input.item-quantity, input.item-price").live("change", function() {
        recalc_line($(this).prop("id").match(/attributes_([new_\d]+)_/)[1]);
    })
    $("input.item-quantity, input.item-price").live("keyup", function() {
        recalc_line($(this).prop("id").match(/attributes_([new_\d]+)_/)[1]);
    })

    $("#invoice_discount").change(function() {
        recalc_totals();
    });
    $("#invoice_discount").keyup(function() {
        recalc_totals();
    });

    $("#invoice_status").change(function() {
        $("#invoice-content").removeClass("draft").removeClass("sent").removeClass("partial-payment").removeClass("paid").addClass($("#invoice_status").val().replace(" ", "-"));
    });

    $("#invoices th a, #invoices .pagination a").live("click", function() {
      $.getScript(this.href);
      return false;
    });
});