$(function() {
  $("#activities th a, #activities .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  
  var execute_remote_search = function() {
    $.get($("#activities_search").attr("action"), $("#activities_search").serialize(), null, "script");
    return false;
  };
  $("#activities_search input").live("keyup", execute_remote_search);  
  
  $("input.date").datepicker({dateFormat : "yy-mm-dd"});
  
  $("#toggle_search_form").click(function(e){
    $("#quick_search").toggle("fast");
    $("#advanced_search").toggle("fast");
    e.preventDefault();
  });
});