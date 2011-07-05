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
  
  $("#toggle_search_form").click(function(e){
    $("#quick_search").toggle("fast");
    $("#advanced_search").toggle("fast");
    e.preventDefault();
  });
});