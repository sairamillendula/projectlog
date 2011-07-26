//= require jquery  
//= require jquery-ui
//= require jquery_ujs  
//= require_tree .

$(function() {
  $("#activities th a, #activities .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  
  var execute_remote_search = function() {
    $.get($("#activities_search").attr("action"), $("#activities_search").serialize(), null, "script");
    return false;
  };
  $("#activities_search").live("submit", execute_remote_search);  
  
  
  $("input.date").live('click', function() {
    $(this).datepicker({showOn:'focus', dateFormat : "yy-mm-dd"}).focus();
  });
    
  $("#quick_search_start_date").change(function(){
    var start_date = new Date(Date.parse($(this).val()));
    var end_date = new Date(start_date.getFullYear(), start_date.getMonth() + 1, 1); // First day of the next month
    end_date = new Date(end_date - 1); // Last second of the current month
    $("#quick_search_end_date").val(end_date.getFullYear() + "-" + (end_date.getMonth() + 1) + "-" + end_date.getDate()); // Convert the date to 'YYYY-MM-DD' format
    return false;
  });
});
